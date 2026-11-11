CREATE MATERIALIZED VIEW public.mv_wildfire_suitable_control_dates AS
WITH calendar_bounds AS (
    SELECT MIN(brand_date) AS min_d, MAX(brand_date) AS max_d FROM public.v_wildfires_intervals
),
full_calendar AS (
    SELECT generate_series((SELECT min_d FROM calendar_bounds), (SELECT max_d FROM calendar_bounds), '1 day'::interval)::date AS c_date
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

CREATE MATERIALIZED VIEW public.mv_wildfire_suitable_control_dates AS
WITH calendar_bounds AS (
    -- limits from historical data
    SELECT 
        MIN(brand_date) AS global_min_date,
        MAX(brand_date) AS global_max_date
    FROM public.v_wildfires_intervals
),
full_calendar AS (
    -- all sequential calendar days within the global bounds
    SELECT generate_series(
        (SELECT global_min_date FROM calendar_bounds),
        (SELECT global_max_date FROM calendar_bounds),
        '1 day'::interval
    )::date AS calendar_date
),
excluded_ranges AS (
    -- all dates blocked by real fires or their safety buffers
    SELECT brand_date AS blocked_date FROM public.v_wildfires_intervals WHERE brand_date IS NOT NULL
    UNION
    SELECT DISTINCT generate_series(period_before_start, period_before_end, '1 day'::interval)::date FROM public.v_wildfires_intervals
    UNION
    SELECT DISTINCT generate_series(period_after_start, period_after_end, '1 day'::interval)::date FROM public.v_wildfires_intervals
),
filtered_suitable_dates AS (
    -- only the untouched "clean gap" calendar days
    SELECT 
        c.calendar_date AS control_date
    FROM 
        full_calendar c
    LEFT JOIN 
        excluded_ranges e ON c.calendar_date = e.blocked_date
    WHERE 
        e.blocked_date IS NULL
)
-- new control dates
SELECT 
    control_date,
    
    -- Calculated time intervals (Before Control Date)
    (control_date - INTERVAL '15 days')::date AS period_before_start,
    (control_date - INTERVAL '1 day')::date AS period_before_end,
    
    -- Calculated time intervals (After Control Date)
    (control_date + INTERVAL '1 day')::date AS period_after_start,
    (control_date + INTERVAL '9 days')::date AS period_after_end,
    
    -- Fixed analytical window metrics
    9 AS period_after_days,
    ((control_date - INTERVAL '1 day')::date - (control_date - INTERVAL '15 days')::date) AS period_before_days
FROM 
    filtered_suitable_dates
ORDER BY 
    control_date ASC;

-- Step 6: Create a unique index for sub-millisecond query search times
CREATE UNIQUE INDEX idx_mv_control_date ON public.mv_wildfire_suitable_control_dates (control_date);
