WITH calendar_bounds AS (
    -- Step 1: Establish the absolute database boundaries
    SELECT 
        MIN(brand_date) AS global_min_date,
        MAX(brand_date) AS global_max_date
    FROM public.v_wildfires_intervals
),
full_calendar AS (
    -- Step 2: Dynamically generate every day in the calendar continuum
    SELECT generate_series(
        (SELECT global_min_date FROM calendar_bounds),
        (SELECT global_max_date FROM calendar_bounds),
        '1 day'::interval
    )::date AS calendar_date
),
excluded_ranges AS (
    -- Step 3: Consolidate all dates that are fire dates or fall inside a buffer
    SELECT DISTINCT brand_date AS blocked_date FROM public.v_wildfires_intervals
    UNION
    SELECT DISTINCT generate_series(period_before_start, period_before_end, '1 day'::interval)::date 
    FROM public.v_wildfires_intervals
    UNION
    SELECT DISTINCT generate_series(period_after_start, period_after_end, '1 day'::interval)::date 
    FROM public.v_wildfires_intervals
)
-- Step 4: Output all unaffected "clean gap" calendar days
SELECT 
    c.calendar_date
FROM 
    full_calendar c
LEFT JOIN 
    excluded_ranges e ON c.calendar_date = e.blocked_date
WHERE 
    e.blocked_date IS NULL
ORDER BY 
    c.calendar_date ASC;
