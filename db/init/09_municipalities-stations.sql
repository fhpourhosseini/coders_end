BEGIN;
-- MAPPING-TABELLE ERSTELLEN (Gemeinde - Wetterstation)

CREATE TABLE IF NOT EXISTS public.gemeinde_station_mapping (
    mapping_id SERIAL PRIMARY KEY,
    gemeinde_id INTEGER NOT NULL REFERENCES public.gemeinde(gemeinde_id) ON DELETE CASCADE,
    station_id INTEGER NOT NULL REFERENCES public.weather_station(station_id) ON DELETE CASCADE,
    rank INTEGER NOT NULL,
    distance_km NUMERIC(8, 2) NOT NULL,
    CONSTRAINT unique_gemeinde_station UNIQUE (gemeinde_id, station_id)
);

-- Index für schnelle Abfragen im ML-Workflow
CREATE INDEX IF NOT EXISTS idx_mapping_gemeinde_rank ON public.gemeinde_station_mapping(gemeinde_id, rank);

-- MAPPING AUTOMATISCH BERECHNEN & BEFÜLLEN (Über gemeinde_id)
WITH gemeinde_centroids AS (
    -- Berechnet den geografischen Mittelpunkt jeder Gemeinde über den direkten ID-Join
    SELECT 
        g.gemeinde_id,
        g.name AS gemeinde_name,
        g.bundesland_code,
        AVG(CASE WHEN w.latitude > 100 THEN w.latitude / 1000.0 ELSE w.latitude END) AS avg_lat,
        AVG(CASE WHEN w.longitude > 100 THEN w.longitude / 1000.0 ELSE w.longitude END) AS avg_lon
    FROM public.gemeinde g
    JOIN public.wildfires w 
        ON w.gemeinde_id = g.gemeinde_id
    WHERE w.latitude IS NOT NULL 
      AND w.longitude IS NOT NULL
    GROUP BY g.gemeinde_id, g.name, g.bundesland_code
),
station_distances AS (
    -- Berechnet die Luftlinie (Haversine-Distanz) zu allen COMBINED-Wetterstationen
    SELECT 
        gc.gemeinde_id,
        ws.station_id,
        (LOWER(gc.gemeinde_name) = LOWER(ws.name) AND gc.bundesland_code = ws.bundesland_code) AS exact_match,
        ROUND(
            (6371 * ACOS(
                LEAST(1.0, GREATEST(-1.0,
                    COS(RADIANS(gc.avg_lat)) * COS(RADIANS(ws.lat)) * COS(RADIANS(ws.lon) - RADIANS(gc.avg_lon)) +
                    SIN(RADIANS(gc.avg_lat)) * SIN(RADIANS(ws.lat))
                ))
            ))::NUMERIC, 2
        ) AS distance_km
    FROM gemeinde_centroids gc
    CROSS JOIN public.klima_stations ws
    WHERE ws.type = 'COMBINED'
),
ranked_stations AS (
    -- Sortiert die Stationen pro Gemeinde (Exakter Name zuerst, dann kürzeste Distanz)
    SELECT 
        gemeinde_id,
        station_id,
        distance_km,
        exact_match,
        ROW_NUMBER() OVER (
            PARTITION BY gemeinde_id 
            ORDER BY exact_match DESC, distance_km ASC
        ) AS rank
    FROM station_distances
)
-- Fügt die Top-3 Stationen pro Gemeinde in die Mapping-Tabelle ein
INSERT INTO public.gemeinde_station_mapping (gemeinde_id, station_id, rank, distance_km)
SELECT 
    gemeinde_id,
    station_id,
    rank,
    distance_km,
    exact_match
FROM ranked_stations
WHERE rank <= 3
ON CONFLICT (gemeinde_id, station_id) DO UPDATE SET
    rank = EXCLUDED.rank,
    distance_km = EXCLUDED.distance_km;

--  einfach WHERE rank = 1
-- Sollte diese Station für ein historisches Jahr keine Daten haben (valid_from > Branddatum), 
-- automatisch auf rank = 2
COMMIT;