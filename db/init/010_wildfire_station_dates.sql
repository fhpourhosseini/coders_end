BEGIN;
-- CREATE TABLE: public.wildfire_station_dates
CREATE TABLE IF NOT EXISTS public.wildfire_station_dates (
    id SERIAL PRIMARY KEY,
    objid INTEGER NOT NULL REFERENCES public.wildfires(objid) ON DELETE CASCADE,
    before_date DATE NOT NULL,
    station_id INTEGER NOT NULL REFERENCES public.klima_stations(station_id) ON DELETE CASCADE,
    CONSTRAINT unique_wildfire_before_station UNIQUE (objid, before_date, station_id)
);

-- POPULATE PRE-FIRE DATES (-15 TO -1) WITH RANK FALLBACK
WITH expanded_before_dates AS (
    -- Expand every calendar day 
    -- from period_before_start to period_before_end
    SELECT 
        v.objid,
        v.gemeinde_id,
        gs.day_series::date AS before_date
    FROM public.v_wildfires_intervals v
    CROSS JOIN LATERAL generate_series(
        v.period_before_start, 
        v.period_before_end, 
        '1 day'::interval
    ) AS gs(day_series)
    WHERE v.period_before_start IS NOT NULL 
      AND v.period_before_end IS NOT NULL
),
ranked_valid_stations AS (
    -- Match each day to the highest-priority 
    -- (lowest rank) station active on that date
    SELECT DISTINCT ON (e.objid, e.before_date)
        e.objid,
        e.before_date,
        gsm.station_id
    FROM expanded_before_dates e
    INNER JOIN public.gemeinde_station_mapping gsm 
        ON e.gemeinde_id = gsm.gemeinde_id
    INNER JOIN public.klima_stations ks 
        ON gsm.station_id = ks.station_id
    WHERE e.before_date >= ks.valid_from::date 
      AND e.before_date <= COALESCE(ks.valid_to::date, '2222-12-22'::date)
    ORDER BY 
        e.objid ASC, 
        e.before_date ASC, 
        gsm.rank ASC
)
-- Insert into target table (overwriting station_id if re-run)
INSERT INTO public.wildfire_station_dates (objid, before_date, station_id)
SELECT 
    objid,
    before_date,
    station_id
FROM ranked_valid_stations
ON CONFLICT (objid, before_date, station_id) DO NOTHING;

-- Create an index on (station_id, before_date) to speed up joins
CREATE INDEX IF NOT EXISTS idx_wsd_station_date 
ON public.wildfire_station_dates (station_id, before_date);

COMMIT;