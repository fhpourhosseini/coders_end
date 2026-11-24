BEGIN;
DO $$
DECLARE
    v_total_rows INT;
    v_null_dates INT;
    v_date_mismatch INT;
    v_invalid_coords INT;
    v_null_gemeinde INT;
    v_negative_area INT;
    v_min_year INT;
    v_max_year INT;
BEGIN
    -- total row count
    SELECT COUNT(*) INTO v_total_rows FROM public.wildfires;
    
    IF v_total_rows = 0 THEN
        RAISE EXCEPTION '>>> VALIDATION FAILED: Table public.wildfires is empty';
    ELSE
        RAISE NOTICE 'Total rows loaded into Table public.wildfires: %', v_total_rows;
    END IF;

    -- missing dates or mismatches 
    SELECT COUNT(*) INTO v_null_dates 
    FROM public.wildfires 
    WHERE brand_date IS NULL;

    SELECT COUNT(*) INTO v_date_mismatch 
    FROM public.wildfires 
    WHERE brand_date IS NOT NULL 
      AND (
          EXTRACT(YEAR FROM brand_date) != jahr OR
          EXTRACT(MONTH FROM brand_date) != monat OR
          EXTRACT(DAY FROM brand_date) != tag
      );

    IF v_date_mismatch > 0 THEN
        RAISE EXCEPTION '>>> VALIDATION FAILED: Found % rows where brand_date does not match', v_date_mismatch;
    ELSE
        RAISE NOTICE 'Date consistency check passed (0 mismatches, % NULL dates).', v_null_dates;
    END IF;

    -- Austrian geographic bounding box (Approx. Lon: 9.5 to 17.2, Lat: 46.3 to 49.1)
    -- Catches unscaled coordinates or swapped lat/lon
    SELECT COUNT(*) INTO v_invalid_coords 
    FROM public.wildfires 
    WHERE longitude IS NOT NULL AND latitude IS NOT NULL
      AND (longitude < 9.4 OR longitude > 17.3 OR latitude < 46.3 OR latitude > 49.1);

    IF v_invalid_coords > 0 THEN
        RAISE EXCEPTION '>>> VALIDATION FAILED: Found % rows with coordinates outside Austria (check for unscaled values > 100 or swapped lat/lon)', v_invalid_coords;
    ELSE
        RAISE NOTICE 'Geographic bounding box check passed';
    END IF;

    -- Foreign Key completeness (unmapped municipalities)
    SELECT COUNT(*) INTO v_null_gemeinde 
    FROM public.wildfires 
    WHERE gemeinde_id IS NULL;

    IF v_null_gemeinde > 0 THEN
        RAISE NOTICE '--- WARNING: % rows have a NULL gemeinde_id, see SELECT * FROM public.wildfires WHERE gemeinde_id IS NULL;', v_null_gemeinde;
    ELSE
        RAISE NOTICE 'Foreign key check passed (All rows linked to a gemeinde_id)';
    END IF;

    -- logical anomalies in burned area
    SELECT COUNT(*) INTO v_negative_area 
    FROM public.wildfires 
    WHERE brandflaeche < 0 OR brandflaeche_korr < 0;

    -- IF v_negative_area > 0 THEN
    --     RAISE EXCEPTION 'VALIDATION FAILED: Found % rows with negative burned area!', v_negative_area;
    -- ELSE
    --     RAISE NOTICE 'Burned area check passed (No negative values)';
    -- END IF;

    -- 6. Summary timeframe notice
    SELECT MIN(jahr), MAX(jahr) INTO v_min_year, v_max_year FROM public.wildfires;
    RAISE NOTICE '=== VALIDATION SUCCESSFUL: Dataset covers years % to % ===', v_min_year, v_max_year;

END $$;

COMMIT;