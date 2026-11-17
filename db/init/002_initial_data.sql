BEGIN;
-- POPULATE BUNDESLAND (States & Capitals)

INSERT INTO public.bundesland (code, name, hauptstadt)
VALUES 
    ('BGLD', 'Burgenland', 'Eisenstadt'),
    ('K',    'Carinthia (Kärnten)', 'Klagenfurt'),
    ('NOE',  'Lower Austria (Niederösterreich)', 'St. Pölten'),
    ('OOE',  'Upper Austria (Oberösterreich)', 'Linz'),
    ('SBG',  'Salzburg', 'Salzburg'),
    ('STMK', 'Styria (Steiermark)', 'Graz'),
    ('T',    'Tyrol (Tirol)', 'Innsbruck'),
    ('VBG',  'Vorarlberg', 'Bregenz'),
    ('W',    'Vienna (Wien)', 'Vienna (Wien)')
ON CONFLICT (code) DO UPDATE SET 
    name = EXCLUDED.name,
    hauptstadt = EXCLUDED.hauptstadt;

-- POPULATE URSACHE (Fire Causes)

INSERT INTO public.ursache (ursache_id, name)
VALUES 
    (0, 'natürlich'),
    (1, 'anthropogen'),
    (2, 'unbekannt')
ON CONFLICT (ursache_id) DO UPDATE SET 
    name = EXCLUDED.name;

UPDATE public.ursache
SET description = 'sämtliche Brandereignisse mit natürlicher Ursache werden dargestellt; in Österreich ist Blitzschlag die einzig natürliche Ursache von Waldbränden'
WHERE ursache_id = 0 OR name = 'natürlich';

UPDATE public.ursache
SET description = 'sämtliche Brandereignisse mit anthropogener Ursache (d.h. direkt oder indirekt durch den Menschen ausgelöst) werden dargestellt; darunter fallen etwa Feuer außer Kontrolle, weggeworfene Zigaretten, Funkenflug von Eisenbahnen, gekappte Stromleitungen, Brandstiftung, heiße Asche u. ä.'
WHERE ursache_id = 1 OR name = 'anthropogen';

UPDATE public.ursache
SET description = 'sämtliche Brandereignisse, bei denen die Ursache unbekannt ist, werden dargestellt'
WHERE ursache_id = 2 OR name = 'unbekannt';

-- POPULATE BRANDART (Fire Types 0 - 7)

INSERT INTO public.brandart (brandart_id, name, description)
VALUES 
    (0, NULL, 'Waldbrand (Forest fire): Pure forest fires affecting forest floor, timber, or young forest stands'),
    (1, NULL, 'Wald-/Latschenbrand (Forest / mountain pine fire): Alpine fires occurring at the timberline or inside dwarf mountain pine (Latschen) zones'),
    (2, NULL, 'Wald-/Flurbrand (Mixed forest / brush or meadow fire): Mixed fires affecting both forest land (at least 10% or 300 m²) and adjacent grassland, scrub, or embankments (Böschungsbrand)'),
    (3, NULL, NULL),
    (4, NULL, NULL),
    (5, NULL, 'Einzelbaumbrand / Baumbrand (Single tree fire): Isolated fires affecting individual trees (often triggered by lightning strikes, e.g., "hohler Baum brannte", "Brand eines Baumes")'),
    (6, NULL, 'Flurbrand (Field, meadow, hedge, or railway embankment fire): Non-forest vegetation fires, including meadows (Wiesenbrand), agricultural fields (Feldbrand / Stoppelfeld), reeds (Schilfbrand), hedges (Heckenbrand), and railway embankments (Bahndammbrand)'),
    (7, NULL, NULL)
ON CONFLICT (brandart_id) DO NOTHING;

UPDATE public.brandart
SET description = 'grouped under Waldbrände (0–2) or alle Vegetationsbrände (0–7) in the public web interface. Waldbrände – sämtliche unkontrollierten Feuer, die lt. Österreichischem Forstgesetz in einem Waldgebiet aufgetreten sind (unabhängig von Brandflächengröße und Art des Brandes); inklusive Feuer an der Waldgrenze/im Latschenbereich, Brände im Bereich von Windschutzgürteln, (bewaldeten) Parkanlagen u. ä.
alle Vegetationsbrände – sämtliche unkontrollierten Feuer im Außenraum, bei denen Vegetation betroffen war; enthält neben allen Waldbränden auch Flurbrände, Heckenbrände, Bahndammbrände, brennende Einzelbäume u. ä.'
WHERE description IS NULL;

UPDATE public.brandart SET name = 'Waldbrand' WHERE brandart_id = 0;
UPDATE public.brandart SET name = 'Wald-/Latschenbrand' WHERE brandart_id = 1;
UPDATE public.brandart SET name = 'Wald-/Flurbrand' WHERE brandart_id = 2;
UPDATE public.brandart SET name = 'Sonstige Waldbrandart (Reserviert)' WHERE brandart_id = 3;
UPDATE public.brandart SET name = 'Sonstige Waldbrandart (Reserviert)' WHERE brandart_id = 4;
UPDATE public.brandart SET name = 'Einzelbaumbrand' WHERE brandart_id = 5;
UPDATE public.brandart SET name = 'Flurbrand' WHERE brandart_id = 6;
UPDATE public.brandart SET name = 'Sonstiger Vegetationsbrand (Reserviert)' WHERE brandart_id = 7;
-- POPULATE GEMEINDE (examples)
INSERT INTO public.gemeinde (name, bundesland_code)
VALUES 
    ('Reißeck', 'K'),
    ('Techelsberg am Wörther See', 'K'),
    ('Kirchdorf in Tirol', 'T'),
    ('Serfaus', 'T'),
    ('St. Egyden am Steinfeld', 'NOE'),
    ('Statzendorf', 'NOE'),
    ('Kilb', 'NOE'),
    ('Strem', 'BGLD'),
    ('Sankt Lorenzen im Mürztal', 'STMK'),
    ('Althofen', 'K'),
    ('Längenfeld', 'T'),
    ('St. Pankraz', 'OOE'),
    ('Steyr', 'OOE'),
    ('Hinterstoder', 'OOE'),
    ('Anras', 'T'),
    ('Loosdorf', 'NOE'),
    ('Ravelsbach', 'NOE'),
    ('Gmünd', 'NOE'),
    ('Köttmannsdorf', 'K'),
    ('Oberwölz', 'STMK'),
    ('Puchberg am Schneeberg', 'NOE'),
    ('Untersiebenbrunn', 'NOE'),
    ('Innervillgraten', 'T'),
    ('Senftenberg', 'NOE'),
    ('Scheiblingkirchen-Thernberg', 'NOE')
ON CONFLICT (name, bundesland_code) DO NOTHING;

-- POPULATE wildfires (examples)
WITH raw_csv (
    objid, waldbrandid, jahr, monat, tag, bundesland, gemeinde, brandart, brandflaeche, 
    ursache, feuerwehren, einsatzkraefte, quelle1, verifiziert, gemeinde_neu, 
    brandflaeche_korr, schutzwald, longitude, latitude
) AS (
    VALUES
        (10729, 2015120702, 2015, 12, 7, 'K', 'Reißeck', 6, 500, 1, 2, 18, 'http://feuerwehr-ktn.at[tt_news]=6373&cHash=b6ba2254b4e51892dacc663a5703c218', true, 'Reißeck', 0.0, -9999, 13.306, 46.884),
        (60259, 2011071101, 2011, 7, 11, 'K', NULL, 0, 200, 1, -9999, -9999, NULL, true, 'Techelsberg am Wörther See', 0.0, 0, 14.075, 46.632),
        (11780, 2011033001, 2011, 3, 30, 'T', 'Kirchdorf in Tirol', 0, 14670, 1, 5, -9999, 'http://feuerwehr-stjohann.at', true, 'Kirchdorf in Tirol', 17020.0, 1, 12.521, 47.566),
        (7401, 2014122401, 2014, 12, 24, 'T', 'Serfaus', 0, 50, 1, 2, 35, 'http://ff-fiss.at', true, 'Serfaus', NULL, 2, 10.591, 47.024),
        (2386, 2013080101, 2013, 8, 1, 'NOE', 'St. Egyden am Steinfeld', 0, 199700, 1, 33, 320, 'http://orf.at', true, 'St. Egyden am Steinfeld', 199720.0, 1, 16.148, 47.773),
        (11208, 2012121101, 2012, 12, 11, 'NOE', 'Statzendorf', 2, 1, 1, 1, -9999, 'http://ff-statzendorf.org', true, 'Statzendorf', NULL, 1, 15.644, 48.307),
        (4032, 2013091201, 2013, 9, 12, 'NOE', 'Kilb', 5, 1, 1, 2, -9999, 'http://bfk-melk.at', true, 'Kilb', 0.0, -9999, 15.381, 48.079),
        (4077, 2013072916, 2013, 7, 29, 'BGLD', 'Strem', 6, 600, 1, 2, -9999, 'http://ff-strem.at', true, 'Strem', 0.0, -9999, 16.399, 47.046),
        (2325, 2013072906, 2013, 7, 29, 'STMK', 'St. Lorenzen im Mürztal', 5, 1, 1, 1, -9999, 'http://feuerwehr-lorenzen.at', true, 'Sankt Lorenzen im Mürztal', 0.0, -9999, 15.379, 47.502),
        (1107, 2011030402, 2011, 3, 4, 'K', 'Althofen', 6, 800, 1, 1, 8, 'http://ff-althofen.at', true, 'Althofen', 0.0, -9999, 14.458, 46.878),
        (11194, 2013040701, 2013, 4, 7, 'T', 'Längenfeld', 6, 10, 2, 1, -9999, 'http://ff-laengenfeld.at', true, 'Längenfeld', 0.0, -9999, 10.96, 47.064),
        (9290, 2015072502, 2015, 7, 25, 'NOE', 'St. Egyden am Steinfeld', 2, 1510, 1, 6, 69, 'http://einsatzdoku.at', true, 'St. Egyden am Steinfeld', 1510.0, 1, 16.149, 47.773),
        (11351, 2012042910, 2012, 4, 29, 'OOE', 'St. Pankraz', 6, 30, 2, 1, -9999, 'http://ff-hinterstoder.at', true, 'St. Pankraz', 0.0, -9999, 14.209, 47.765),
        (11455, 2012032206, 2012, 3, 22, 'OOE', 'Steyr', 6, 300, 1, 1, 29, 'http://ff-steyr.at', true, 'Steyr', 0.0, -9999, 14.456, 48.057),
        (2702, 2013080701, 2013, 8, 7, 'OOE', 'Klaus an der Pyhrnbahn', 1, 9450, 0, 3, 35, 'http://fireworld.at', true, 'Hinterstoder', 17830.0, 1, 14.137, 47.745),
        (57, 2013041103, 2013, 4, 11, 'T', 'Anras', 6, 500, 1, 1, 24, 'http://ff-anras.at', true, 'Anras', 0.0, -9999, 12.577, 46.782),
        (11557, 2012011201, 2012, 1, 12, 'NOE', 'Loosdorf', 6, 20, 1, 1, -9999, 'http://netteam.at', true, 'Loosdorf', 0.0, -9999, 15.416, 48.209),
        (1441, 2011123106, 2011, 12, 31, 'NOE', 'Ravelsbach', 5, 3, 1, 2, 37, 'http://ffmaissau.at', true, 'Ravelsbach', 0.0, -9999, 15.833, 48.558),
        (1520, 2012032509, 2012, 3, 25, 'NOE', 'Gmünd', 6, 500, 1, 3, -9999, 'http://markusb.at', true, 'Gmünd', 0.0, -9999, 14.981, 48.795),
        (2155, 2013072603, 2013, 7, 26, 'K', 'Köttmannsdorf', 0, 500, 1, 4, 80, 'http://feuerwehr-ferlach.at', true, 'Köttmannsdorf', NULL, 0, 14.268, 46.549),
        (5302, 2014033001, 2014, 3, 30, 'STMK', 'Oberwölz Umgebung', 2, 100, 1, 1, 25, 'http://feuerwehr-oberwoelz.at', true, 'Oberwölz', 0.0, 0, 14.292, 47.202),
        (7167, 2015031801, 2015, 3, 18, 'NOE', 'Puchberg am Schneeberg', 2, 3000, 1, 1, -9999, 'http://ff-puchberg.at', true, 'Puchberg am Schneeberg', 0.0, 0, 15.889, 47.782),
        (6125, 2014062501, 2014, 6, 25, 'NOE', 'Untersiebenbrunn', 2, 100000, 1, 4, -9999, 'http://feuerwehr-untersiebenbrunn.at', true, 'Untersiebenbrunn', 0.0, 1, 16.75, 48.274),
        (11729, 2011042101, 2011, 4, 21, 'T', 'Innervillgraten', 2, 72050, 1, 3, 130, 'http://orf.at', true, 'Innervillgraten', 88900.0, 2, 12.313, 46.86),
        (9110, 2015072203, 2015, 7, 22, 'NOE', 'Senftenberg', 2, 15000, 1, 7, -9999, 'http://fireworld.at', true, 'Senftenberg', 0.0, 0, 15.504, 48.475),
        (2469, 2013073101, 2013, 7, 31, 'NOE', 'Scheiblingkirchen-Thernberg', 2, 25000, 1, 3, -9999, 'http://ff-scheiblingkirchen.org', true, 'Scheiblingkirchen-Thernberg', 0.0, 0, 16.165, 47.666)
)
INSERT INTO public.wildfires (
    objid, waldbrandid, brand_date, jahr, monat, tag, gemeinde_id, brandart_id, ursache_id,
    brandflaeche, brandflaeche_korr, feuerwehren, einsatzkraefte, quelle1, verifiziert,
    schutzwald, longitude, latitude
)
SELECT 
    r.objid,
    r.waldbrandid,
    make_date(r.jahr, r.monat, r.tag) AS brand_date,
    r.jahr,
    r.monat,
    r.tag,
    g.gemeinde_id,
    NULLIF(r.brandart, -9999) AS brandart_id,
    NULLIF(r.ursache, -9999) AS ursache_id,
    NULLIF(r.brandflaeche, -9999) AS brandflaeche,
    NULLIF(r.brandflaeche_korr, -9999) AS brandflaeche_korr,
    NULLIF(r.feuerwehren, -9999) AS feuerwehren,
    NULLIF(r.einsatzkraefte, -9999) AS einsatzkraefte,
    r.quelle1,
    r.verifiziert,
    NULLIF(r.schutzwald, -9999)::SMALLINT AS schutzwald,
    NULLIF(r.longitude, -9999) AS longitude,
    NULLIF(r.latitude, -9999) AS latitude
FROM raw_csv r
LEFT JOIN public.gemeinde g 
    ON g.name = COALESCE(NULLIF(TRIM(r.gemeinde_neu), ''), TRIM(r.gemeinde))
    AND g.bundesland_code = TRIM(r.bundesland)
ON CONFLICT (objid) DO UPDATE SET
    waldbrandid = EXCLUDED.waldbrandid,
    brand_date = EXCLUDED.brand_date,
    jahr = EXCLUDED.jahr,
    monat = EXCLUDED.monat,
    tag = EXCLUDED.tag,
    gemeinde_id = EXCLUDED.gemeinde_id,
    brandart_id = EXCLUDED.brandart_id,
    ursache_id = EXCLUDED.ursache_id,
    brandflaeche = EXCLUDED.brandflaeche,
    brandflaeche_korr = EXCLUDED.brandflaeche_korr,
    feuerwehren = EXCLUDED.feuerwehren,
    einsatzkraefte = EXCLUDED.einsatzkraefte,
    quelle1 = EXCLUDED.quelle1,
    verifiziert = EXCLUDED.verifiziert,
    schutzwald = EXCLUDED.schutzwald,
    longitude = EXCLUDED.longitude,
    latitude = EXCLUDED.latitude;

COMMIT;