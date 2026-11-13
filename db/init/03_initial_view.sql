BEGIN;

CREATE OR REPLACE VIEW public.v_wildfires_intervals AS
SELECT 
    objid,
    waldbrandid,
    brand_date,
    gemeinde_id,
    longitude,
    latitude,
    
    -- Calculated time intervals (Before Fire Event)
    (brand_date - INTERVAL '15 days')::date AS period_before_start,
    (brand_date - INTERVAL '1 day')::date AS period_before_end,
    
    -- Calculated time intervals (After Fire Event)
    (brand_date + INTERVAL '1 day')::date AS period_after_start,
    (brand_date + INTERVAL '15 days')::date AS period_after_end,
    
    -- Fixed tracking day counts derived directly from intervals
    ((brand_date + INTERVAL '15 days')::date - (brand_date + INTERVAL '1 day')::date) AS period_after_days,
    ((brand_date - INTERVAL '1 day')::date - (brand_date - INTERVAL '15 days')::date) AS period_before_days
FROM 
    public.wildfires;

CREATE MATERIALIZED VIEW public.mv_wildfire_suitable_control_dates AS
WITH calendar_bounds AS (
    SELECT 
    MIN(brand_date) AS min_d, 
    MAX(brand_date) AS max_d 
    FROM public.v_wildfires_intervals
),
full_calendar AS (
    SELECT generate_series(
        (SELECT min_d FROM calendar_bounds), 
        (SELECT max_d FROM calendar_bounds), '10 days'::interval)::date AS c_date
),
excluded_ranges AS (
    SELECT brand_date AS b_date FROM public.v_wildfires_intervals WHERE brand_date IS NOT NULL
    UNION
    SELECT DISTINCT generate_series(period_before_start, period_before_end, '1 day'::interval)::date FROM public.v_wildfires_intervals
    UNION
    SELECT DISTINCT generate_series(period_after_start, period_after_end, '1 day'::interval)::date FROM public.v_wildfires_intervals
)
SELECT c_date AS suitable_date 
FROM full_calendar 
WHERE c_date NOT IN (SELECT b_date FROM excluded_ranges) 
ORDER BY c_date;

-- Add a unique index to optimize lookups down the road
CREATE UNIQUE INDEX idx_mv_suitable_date ON public.mv_wildfire_suitable_control_dates (suitable_date);

-- Note: If you append or edit records in public.wildfires in the future, 
-- you simply run REFRESH MATERIALIZED VIEW public.mv_wildfire_suitable_control_dates; 
-- to instantly synchronize data layers.

COMMIT;