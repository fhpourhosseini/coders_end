BEGIN;
CREATE TABLE IF NOT EXISTS public.klima_data (
    id SERIAL UNIQUE,
    obs_date DATE NOT NULL,
    "time" TIMESTAMPTZ NOT NULL,
    station INTEGER NOT NULL REFERENCES public.klima_stations(station_id) ON DELETE CASCADE,
    substation INTEGER NULL REFERENCES public.klima_stations(station_id) ON DELETE SET NULL,
    
    -- Temperature parameters (°C)
    tl_ii DOUBLE PRECISION NULL,
    tlmax DOUBLE PRECISION NULL,
    tl_mittel DOUBLE PRECISION NULL,
    
    -- Wind parameters (Beaufort & m/s)
    vvbft_ii SMALLINT NULL,
    vv_mittel DOUBLE PRECISION NULL,
    
    -- Humidity parameters (%)
    rfb_ii DOUBLE PRECISION NULL,
    rfb_mittel DOUBLE PRECISION NULL,
    rf_ii DOUBLE PRECISION NULL,
    rf_mittel DOUBLE PRECISION NULL,
    
    -- Precipitation, Snow & Pressure (mm, cm, hPa)
    rr_iii DOUBLE PRECISION NULL,
    sh DOUBLE PRECISION NULL,
    p_mittel DOUBLE PRECISION NULL,
    
    -- Composite Primary Key to avoid duplicate station-date downloads
    CONSTRAINT pk_klima_data PRIMARY KEY (station, obs_date)
);

-- Index to speed up lookups by physical sensor (substation)
CREATE INDEX IF NOT EXISTS idx_klima_data_substation 
ON public.klima_data (substation);

CREATE OR REPLACE VIEW public.v_wildfires_klima_series AS
SELECT 
    -- Wildfire identifiers & coordinates
    w.objid AS serie_id,
    ROW_NUMBER() OVER ( PARTITION BY w.objid ORDER BY wsd.before_date ASC) AS serial_number,
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
COMMIT;