BEGIN;
-- GEMEINDEN 
DO $$
DECLARE
    v_expected_count INT := 1560;
    v_total_count INT;
    v_missing_fields INT;
    v_orphan_states INT;
    v_duplicate_pairs INT;
    v_missing_expected INT;
BEGIN
    -- 1. Check total count (Expected: 25 unique municipalities from your CSV snippet)
    SELECT COUNT(*) INTO v_total_count
    FROM public.gemeinde;

    IF v_total_count < v_expected_count THEN
        RAISE EXCEPTION 'GEMEINDE LOAD ERROR: Expected % unique municipalities, but found %.', v_expected_count, v_total_count;
    END IF;

    -- 2. Check for NULL or empty names / state codes
    SELECT COUNT(*) INTO v_missing_fields
    FROM public.gemeinde
    WHERE name IS NULL 
       OR TRIM(name) = '' 
       OR bundesland_code IS NULL 
       OR TRIM(bundesland_code) = '';

    IF v_missing_fields > 0 THEN
        RAISE EXCEPTION 'GEMEINDE LOAD ERROR: Found % rows with empty name or bundesland_code.', v_missing_fields;
    END IF;

    -- 3. Check for orphaned bundesland_code references (if FK isn't strictly enforced)
    SELECT COUNT(*) INTO v_orphan_states
    FROM public.gemeinde g
    LEFT JOIN public.bundesland b ON g.bundesland_code = b.code
    WHERE b.code IS NULL;

    IF v_orphan_states > 0 THEN
        RAISE EXCEPTION 'GEMEINDE LOAD ERROR: Found % municipalities with an invalid bundesland_code.', v_orphan_states;
    END IF;

    -- 4. Check for duplicate (name, bundesland_code) pairs
    SELECT COUNT(*) INTO v_duplicate_pairs
    FROM (
        SELECT name, bundesland_code
        FROM public.gemeinde
        GROUP BY name, bundesland_code
        HAVING COUNT(*) > 1
    ) dupes;

    IF v_duplicate_pairs > 0 THEN
        RAISE EXCEPTION 'GEMEINDE LOAD ERROR: Found % duplicate (name, bundesland_code) combinations.', v_duplicate_pairs;
    END IF;

    RAISE NOTICE 'VALIDATION PASSED: All % unique municipalities loaded cleanly into public.gemeinde.', v_total_count;
END $$;

COMMIT;