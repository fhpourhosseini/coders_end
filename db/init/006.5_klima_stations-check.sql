BEGIN;
DO $$
DECLARE
    
    v_total_count INT;
    v_combined_count INT;
    v_individual_count INT;
BEGIN
    -- Query current totals in the table
    SELECT 
        COUNT(*),
        COUNT(*) FILTER (WHERE type = 'COMBINED'),
        COUNT(*) FILTER (WHERE type = 'INDIVIDUAL')
    INTO v_total_count, v_combined_count, v_individual_count
    FROM public.klima_stations;

    -- Print summary to the Messages tab
    RAISE NOTICE '=== Table public.klima_stations total: % (% COMBINED, % INDIVIDUAL)', 
        v_total_count, v_combined_count, v_individual_count;
END $$;
COMMIT;

DO $$
DECLARE
    -- Expected counts 
    -- • Total count: 1102 ?? stations 
    -- • Min ID: 1 (Aflenz) • Max ID: 21302 (Eisenkappel)
    -- • Count of groups: 104 unique group_ids
    -- • Combined stations: 216
    -- • Individual stations: 886 ?? 
    v_exp_combined      INT := 216;
    v_exp_individual INT := 886;
    
    -- Actual database counts
    v_combined_count      INT;
    v_individual_count    INT;
    v_total_count         INT;
    v_unmapped_states     INT;
    v_orphaned_groups     INT;
    v_invalid_coords_dates INT;
    v_missing_key_ids     INT;
BEGIN
    -- loaded station counts
    SELECT 
        COUNT(*) FILTER (WHERE type = 'COMBINED'),
        COUNT(*) FILTER (WHERE type = 'INDIVIDUAL'),
        COUNT(*)
    INTO v_combined_count, v_individual_count, v_total_count
    FROM public.klima_stations;

    -- exact row counts
    IF v_combined_count <> v_exp_combined THEN
        RAISE EXCEPTION 'STATION LOAD ERROR: Expected % COMBINED stations, but found %.', 
            v_exp_combined, v_combined_count;
    END IF;

    IF v_individual_count <> v_exp_individual THEN
        RAISE EXCEPTION 'STATION LOAD ERROR: Expected % INDIVIDUAL stations, but found %.', 
            v_exp_individual, v_individual_count;
    END IF;

    -- unmapped states (bundesland_code is NULL)
    SELECT COUNT(*) INTO v_unmapped_states
    FROM public.klima_stations
    WHERE bundesland_code IS NULL OR state IS NULL;

    IF v_unmapped_states > 0 THEN
        RAISE EXCEPTION 'STATION LOAD ERROR: Found % stations with missing state or bundesland_code.', v_unmapped_states;
    END IF;

    -- orphaned group_id references (every INDIVIDUAL group_id must match a COMBINED station_id)
    SELECT COUNT(*) INTO v_orphaned_groups
    FROM public.klima_stations ind
    LEFT JOIN public.klima_stations grp 
        ON ind.group_id = grp.station_id 
        AND grp.type = 'COMBINED'
    WHERE ind.type = 'INDIVIDUAL'
      AND ind.group_id IS NOT NULL
      AND grp.station_id IS NULL;

    IF v_orphaned_groups > 0 THEN
        RAISE EXCEPTION 'STATION LOAD ERROR: Found % INDIVIDUAL stations pointing to a non-existent COMBINED group_id.', v_orphaned_groups;
    END IF;

    -- missing coordinates or invalid valid_from/valid_to dates
    SELECT COUNT(*) INTO v_invalid_coords_dates
    FROM public.klima_stations
    WHERE lat IS NULL 
       OR lon IS NULL 
       OR valid_from IS NULL 
       OR valid_from > COALESCE(valid_to, '2100-12-31'::timestamptz);

    IF v_invalid_coords_dates > 0 THEN
        RAISE EXCEPTION 'STATION LOAD ERROR: Found % stations with missing coordinates or invalid date ranges.', v_invalid_coords_dates;
    END IF;

    -- IDs from the attached JSON (13400, 278, 500, 21302)
    SELECT COUNT(*) INTO v_missing_key_ids
    FROM (VALUES (13400), (278), (500), (21302)) AS req(id)
    LEFT JOIN public.klima_stations ks ON req.id = ks.station_id
    WHERE ks.station_id IS NULL;

    IF v_missing_key_ids > 0 THEN
        RAISE EXCEPTION 'STATION LOAD ERROR: % boundary station IDs (from 1, 278, 500, 21302) are missing.', v_missing_key_ids;
    END IF;

    -- If all checks pass:
    RAISE NOTICE '=== VALIDATION PASSED: All % stations (% COMBINED, % INDIVIDUAL) verified cleanly with zero errors.', 
        v_total_count, v_combined_count, v_individual_count;
END $$;

COMMIT;