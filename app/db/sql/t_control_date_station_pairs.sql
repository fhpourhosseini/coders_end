DROP TABLE IF EXISTS control_date_station_pairs;

CREATE TABLE control_date_station_pairs AS
WITH 
-- Define the overall date boundaries
date_bounds AS (
    SELECT 
        MIN(brand_date) AS min_date,
        MAX(brand_date) AS max_date
    FROM public.wildfires
),

-- Expand Stations into daily active records 
active_station_days AS (
    SELECT 
        s.name, s.state,s.bundesland_code,
        gs.dt::date AS calendar_date,
        COUNT(DISTINCT s.station_id) AS active_st_count
    FROM public.klima_stations s
    CROSS JOIN date_bounds db
    CROSS JOIN LATERAL generate_series(
        GREATEST(s.valid_from, db.min_date),
        LEAST(s.valid_to, db.max_date),
        INTERVAL '1 day'
    ) AS gs(dt)
    WHERE s.valid_from <= db.max_date 
      AND s.valid_to >= db.min_date
    GROUP BY s.name, s.state, s.bundesland_code, gs.dt::date
),

-- Expand Existing Events into their 29-day blocked windows [T-14 to T+14]
blocked_venue_days AS (
    SELECT DISTINCT
        e.gemeinde_id,m.name as gemeinde_name, m.bundesland_code,
        gs.dt::date AS blocked_date,
        1 AS is_blocked
    FROM public.wildfires e
    JOIN public.gemeinde m ON m.gemeinde_id=e.gemeinde_id
    CROSS JOIN LATERAL generate_series(
        e.brand_date - INTERVAL '14 days',
        e.brand_date + INTERVAL '14 days',
        INTERVAL '1 day'
    ) AS gs(dt)
),

-- Build the Master Grid (Only for municipalities that have >= 1 station)
valid_municipalities AS (
    SELECT DISTINCT name, state,bundesland_code FROM active_station_days
),
master_grid AS (
    SELECT 
        vm.name as gemeinde_name, vm.state,vm.bundesland_code,
        gs.dt::date AS calendar_date,
        COALESCE(asd.active_st_count, 0) AS active_stations,
        CASE WHEN COALESCE(asd.active_st_count, 0) >= 1 THEN 1 ELSE 0 END AS has_station,
        COALESCE(bvd.is_blocked, 0) AS is_blocked
    FROM valid_municipalities vm
    CROSS JOIN date_bounds db
    CROSS JOIN LATERAL generate_series(db.min_date, db.max_date, INTERVAL '1 day') AS gs(dt)
    LEFT JOIN active_station_days asd 
        ON vm.name = asd.name AND vm.state = asd.state AND gs.dt::date = asd.calendar_date
    LEFT JOIN blocked_venue_days bvd 
        ON 
        (LOWER(vm.name) = LOWER(bvd.gemeinde_name) AND bvd.bundesland_code = vm.bundesland_code)
         AND gs.dt::date = bvd.blocked_date
),

-- Apply Window Checks per Municipality
window_evaluations AS (
    SELECT 
        gemeinde_name, state,bundesland_code,
        calendar_date AS candidate_event_date,
        
        -- Venue Check: Sum of blocked days in [T-14, T+14] must be 0
        SUM(is_blocked) OVER (
            PARTITION BY gemeinde_name, state 
            ORDER BY calendar_date 
            ROWS BETWEEN 14 PRECEDING AND 14 FOLLOWING
        ) AS blocked_days_in_29d_window,
        
        -- Edge Check: Ensure we aren't cut off at the very start/end of the dataset
        COUNT(*) OVER (
            PARTITION BY gemeinde_name, state
            ORDER BY calendar_date 
            ROWS BETWEEN 14 PRECEDING AND 14 FOLLOWING
        ) AS total_days_in_29d_window,

        -- Supply Check: Sum of shop-active days in [T-14, T-1] must be 14
        SUM(has_station) OVER (
            PARTITION BY gemeinde_name, state 
            ORDER BY calendar_date 
            ROWS BETWEEN 14 PRECEDING AND 1 PRECEDING
        ) AS shop_ready_days_in_14d_prep,

        -- Optional Metric: Minimum number of shops open during the 14-day prep
        MIN(active_stations) OVER (
            PARTITION BY gemeinde_name, state
            ORDER BY calendar_date 
            ROWS BETWEEN 14 PRECEDING AND 1 PRECEDING
        ) AS min_active_shops_during_prep
    FROM master_grid
),
-- Generate the +10 Day Stepping Calendar
stepped_calendar AS (
    SELECT gs::date AS step_date
    FROM date_bounds db
    CROSS JOIN LATERAL generate_series(
        db.min_date + INTERVAL '14 days', -- First possible date with a full 14-day prep window
        db.max_date - INTERVAL '14 days', -- Last possible date with a full 14-day dismantle window
        INTERVAL '10 days'
    ) AS gs
),
-- Feasible Dates and Municipalities
control_dates AS (
    SELECT 
        gemeinde_name, state,bundesland_code,
        candidate_event_date AS valid_control_date
    FROM window_evaluations we
	JOIN stepped_calendar sc   -- +10 Day Stepping Calendar
        ON we.candidate_event_date = sc.step_date
WHERE we.total_days_in_29d_window = 29          -- Ensures full 14d setup & 14d dismantle fit in range
  AND we.blocked_days_in_29d_window = 0         -- Strictly zero overlap with existing events
  AND we.shop_ready_days_in_14d_prep = 14       -- Every prep day has >= 1 active local shop
ORDER BY gemeinde_name, state, valid_control_date
)

-- Pair each valid control date with station_IDs
SELECT 
    cd.valid_control_date, s.station_id, cd.gemeinde_name, cd.state,
    -- Calculate how many of the 14 prep days [T-14 to T-1] this specific station is open
(
    LEAST(s.valid_to::date, (cd.valid_control_date - INTERVAL '1 day')::date) 
    - GREATEST(s.valid_from::date, (cd.valid_control_date - INTERVAL '14 days')::date) 
    + 1
) AS prep_days_covered_by_station FROM control_dates cd
JOIN public.klima_stations s 
    ON (LOWER(s.name) = LOWER(cd.gemeinde_name) AND s.bundesland_code = cd.bundesland_code)
   -- Shop must be open for at least 1 day during the 14-day prep window [T-14, T-1]
   AND s.valid_from::date <= (cd.valid_control_date - INTERVAL '1 day')::date
   AND s.valid_to::date >= (cd.valid_control_date - INTERVAL '14 days')::date
ORDER BY cd.valid_control_date, cd.gemeinde_name, cd.state, s.station_id;

ALTER TABLE public.control_date_station_pairs 
ADD PRIMARY KEY (valid_control_date, station_id);

ALTER TABLE IF EXISTS public.control_date_station_pairs 
ADD COLUMN IF NOT EXISTS api_request text;

ALTER TABLE IF EXISTS public.control_date_station_pairs 
ADD COLUMN IF NOT EXISTS status character varying(20) DEFAULT 'pending'::character varying;