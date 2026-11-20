-- OVERALL & TYPE-LEVEL ROW COUNTS
-- Expected: 121 COMBINED + 228 INDIVIDUAL = 349 Total Stations

SELECT 
    COALESCE(type, 'TOTAL') AS station_type,
    COUNT(*) AS loaded_count,
    MIN(station_id) AS min_id,
    MAX(station_id) AS max_id,
    COUNT(*) FILTER (WHERE is_active = true) AS active_stations,
    COUNT(*) FILTER (WHERE is_active = false) AS historical_stations
FROM public.klima_stations
GROUP BY ROLLUP(type)
ORDER BY station_type NULLS LAST;


-- CHECK FOR MISSING OR UNMAPPED bundesland_code FOREIGN KEYS
-- Expected: 0 rows (every station should map cleanly to a bundesland_code)

SELECT 
    station_id, 
    type, 
    name, 
    state, 
    bundesland_code
FROM public.klima_stations
WHERE bundesland_code IS NULL 
   OR state IS NULL;

-- CHECK FOR ORPHANED GROUP_ID REFERENCES
-- Verifies that every INDIVIDUAL station's group_id points to a valid COMBINED station
-- Expected: 0 rows

SELECT 
    ind.station_id AS individual_id,
    ind.name AS individual_name,
    ind.group_id AS missing_parent_group_id
FROM public.klima_stations ind
LEFT JOIN public.klima_stations grp 
    ON ind.group_id = grp.station_id 
    AND grp.type = 'COMBINED'
WHERE ind.type = 'INDIVIDUAL'
  AND ind.group_id IS NOT NULL
  AND grp.station_id IS NULL;

-- ============================================================================
-- 4. CHECK FOR MISSING COORDINATES OR INVALID DATE RANGES
-- Expected: 0 rows
-- ============================================================================
SELECT 
    station_id, 
    type, 
    name, 
    lat, 
    lon, 
    valid_from, 
    valid_to
FROM public.klima_stations
WHERE lat IS NULL 
   OR lon IS NULL
   OR valid_from IS NULL
   OR valid_from > COALESCE(valid_to, '2100-12-31'::timestamptz);