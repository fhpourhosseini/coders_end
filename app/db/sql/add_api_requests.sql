UPDATE public.wildfire_station_dates
SET api_request = 
    'https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v2-1d'
    || '?parameters=tl_ii&parameters=tlmax&parameters=vvbft_ii&parameters=rfb_ii'
    || '&parameters=rf_ii&parameters=rf_mittel&parameters=rr_iii&parameters=sh'
    || '&parameters=p_mittel&parameters=rfb_mittel&parameters=tl_mittel&parameters=vv_mittel'
    || '&start=' || TO_CHAR(before_date, 'YYYY-MM-DD') || 'T00%3A00%3A00'
    || '&end=' || TO_CHAR(before_date, 'YYYY-MM-DD') || 'T00%3A00%3A00'
    || '&station_ids=' || station_id::TEXT
    || '&output_format=csv'
    || '&filename=geosphere.at_' || TO_CHAR(before_date, 'YYYY-MM-DD') || '_' || station_id::TEXT || '_dataset.csv';