-- MAPPING-TABELLE ERSTELLEN (Gemeinde - Wetterstation)

CREATE TABLE IF NOT EXISTS public.gemeinde_station_mapping (
    mapping_id SERIAL PRIMARY KEY,
    gemeinde_id INTEGER NOT NULL REFERENCES public.gemeinde(gemeinde_id) ON DELETE CASCADE,
    station_id INTEGER NOT NULL REFERENCES public.klima_stations(station_id) ON DELETE CASCADE,
    rank INTEGER NOT NULL,                -- 1 = Nächste Station, 2 = Zweitnächste, 3 = Drittnächste
    distance_km NUMERIC(8, 2) NOT NULL,   -- Luftlinie in Kilometern
    is_exact_name_match BOOLEAN DEFAULT FALSE,
    CONSTRAINT unique_gemeinde_station UNIQUE (gemeinde_id, station_id)
);

-- Index für schnelle Abfragen im ML-Workflow
CREATE INDEX IF NOT EXISTS idx_mapping_gemeinde_rank ON public.gemeinde_station_mapping(gemeinde_id, rank);

-- MAPPING AUTOMATISCH BERECHNEN & BEFÜLLEN (Haversine-Formel)

WITH gemeinde_centroids AS (
    -- Berechnet den geografischen Mittelpunkt jeder Gemeinde aus den Brandkoordinaten
    -- (inkl. automatischer Korrektur für Koordinaten ohne Dezimalpunkt > 100)
    SELECT 
        g.gemeinde_id,
        g.name AS gemeinde_name,
        g.bundesland_code,
        AVG(CASE WHEN w.latitude > 100 THEN w.latitude / 1000.0 ELSE w.latitude END) AS avg_lat,
        AVG(CASE WHEN w.longitude > 100 THEN w.longitude / 1000.0 ELSE w.longitude END) AS avg_lon
    FROM public.gemeinde g
    JOIN public.wildfires w 
        ON COALESCE(NULLIF(TRIM(w.gemeinde_neu), ''), TRIM(w.gemeinde)) = g.name 
        AND TRIM(w.bundesland) = g.bundesland_code
    WHERE w.latitude IS NOT NULL AND w.longitude IS NOT NULL
    GROUP BY g.gemeinde_id, g.name, g.bundesland_code
),
station_distances AS (
    -- Berechnet die Distanz jeder Gemeinde zu allen COMBINED-Wetterstationen
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
    WHERE ws.type = 'COMBINED' -- Nur kombinierte Hauptstationen mit langen Zeitreihen nutzen
),
ranked_stations AS (
    -- Sortiert die Stationen pro Gemeinde (Exakter Name zuerst, dann nach kürzester Distanz)
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
INSERT INTO public.gemeinde_station_mapping (gemeinde_id, station_id, rank, distance_km, is_exact_name_match)
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
    distance_km = EXCLUDED.distance_km,
    is_exact_name_match = EXCLUDED.is_exact_name_match;
