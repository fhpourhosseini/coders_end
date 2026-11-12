-- UPDATE & POPULATE BUNDESLAND (States & Capitals)

ALTER TABLE public.bundesland 
ADD COLUMN IF NOT EXISTS hauptstadt VARCHAR(100) NULL;

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
ALTER TABLE public.ursache 
ADD COLUMN IF NOT EXISTS description TEXT NULL;
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
ALTER TABLE public.brandart 
ADD COLUMN IF NOT EXISTS description TEXT NULL;
INSERT INTO public.brandart (brandart_id, name, description)
VALUES 
    (0, NULL, 'Waldbrand (Forest fire): Pure forest fires affecting forest floor, timber, or young forest stands'),
    (1, NULL, 'Wald-/Latschenbrand (Forest / mountain pine fire): Alpine fires occurring at the timberline or inside dwarf mountain pine (Latschen) zones'),
    (2, NULL, 'Wald-/Flurbrand (Mixed forest / brush or meadow fire): Mixed fires affecting both forest land (at least 10% or 300 m²) and adjacent grassland, scrub, or embankments (Böschungsbrand)'),
    (3, NULL),
    (4, NULL),
    (5, NULL, 'Einzelbaumbrand / Baumbrand (Single tree fire): Isolated fires affecting individual trees (often triggered by lightning strikes, e.g., "hohler Baum brannte", "Brand eines Baumes")'),
    (6, NULL, 'Flurbrand (Field, meadow, hedge, or railway embankment fire): Non-forest vegetation fires, including meadows (Wiesenbrand), agricultural fields (Feldbrand / Stoppelfeld), reeds (Schilfbrand), hedges (Heckenbrand), and railway embankments (Bahndammbrand)'),
    (7, NULL)
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
