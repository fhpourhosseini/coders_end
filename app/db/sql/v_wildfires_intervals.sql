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
    (brand_date + INTERVAL '9 days')::date AS period_after_end,
    
    -- Fixed tracking day counts derived directly from intervals
    9 AS period_after_days,
    ((brand_date - INTERVAL '1 day')::date - (brand_date - INTERVAL '15 days')::date) AS period_before_days
FROM 
    public.wildfires;
