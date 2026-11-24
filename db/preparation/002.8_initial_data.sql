BEGIN;
-- POPULATE wildfires (examples)

COPY public.wildfires (
    objid,
    waldbrandid,
    brand_date,
    jahr,
    monat,
    tag,
    gemeinde_id,
    brandart_id,
    ursache_id,
    brandflaeche,
    brandflaeche_korr,
    feuerwehren,
    einsatzkraefte,
    quelle1,
    verifiziert,
    schutzwald,
    longitude,
    latitude
)
FROM '/docker-entrypoint-initdb.d/data/wildfires.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    NULL 'NULL',
    ENCODING 'UTF8'
);
COMMIT;