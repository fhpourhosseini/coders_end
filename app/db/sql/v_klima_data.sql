CREATE OR REPLACE VIEW public.v_wildfires_klima_series AS
SELECT 
    -- Wildfire identifiers & coordinates
    w.objid AS serie_id,
    ROW_NUMBER() OVER (
        PARTITION BY w.objid 
        ORDER BY wsd.before_date ASC
    ) AS serial_number,
    wsd.before_date AS obs_date,
    w.longitude,
    w.latitude,
    
    -- Weather observations from public.klima_data
    kd.tl_ii,
    kd.tlmax,
    kd.tl_mittel,
    kd.vvbft_ii,
    kd.vv_mittel,
    kd.rfb_ii,
    kd.rfb_mittel,
    kd.rf_ii,
    kd.rf_mittel,
    kd.rr_iii,
    kd.sh,
    kd.p_mittel
FROM 
    public.wildfires w
INNER JOIN 
    public.wildfire_station_dates wsd 
    ON w.objid = wsd.objid
LEFT JOIN 
    public.klima_data kd 
    ON wsd.station_id = kd.station 
    AND wsd.before_date = kd.obs_date;