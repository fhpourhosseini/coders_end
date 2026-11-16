-- CREATE TABLE: klima_params_legende
CREATE TABLE IF NOT EXISTS public.klima_params_legende (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    units VARCHAR(20) NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL
);

-- POPULATE SELECTED WEATHER PARAMETERS

INSERT INTO public.klima_params_legende (code, units, name, description)
VALUES 
    (
        'tl_ii', 
        '°C', 
        'Lufttemperatur 2m zum Beobachtungstermin II', 
        'Lufttemperatur in 2m Höhe zum Beobachtungstermin II (13 UTC)'
    ),
    (
        'tlmax', 
        '°C', 
        'Lufttemperatur 2m Maximalwert', 
        'Lufttemperatur in 2m Höhe, Maximum der Zehnminutenwerte (tlmax) von 18:10 UTC Vortag - 18:00 UTC aktueller Tag'
    ),
    (
        'tl_mittel', 
        '°C', 
        'Lufttemperatur 2m Mittelwert', 
        'Lufttemperatur in 2m Höhe, Mittelwert berechnet aus (tlmax + tlmin)/2'
    ),
    (
        'vvbft_ii', 
        'Beaufort', 
        'Windstärke zum Beobachtungstermin II', 
        'Windstärke in Beaufort, aus dem Stundenwert zum Beobachtungstermin II (13 UTC)'
    ),
    (
        'vv_mittel', 
        'm/s', 
        'Windgeschwindigkeit Mittelwert', 
        'Windgeschwindigkeit, Tagesmittel aus den Beobachtungsterminen I,II,III (06,13,18 UTC)'
    ),
    (
        'rfb_ii', 
        '%', 
        'Relative Feuchte aus Feuchttemperatur zum Beobachtungstermin II', 
        'Relative Feuchte, berechnet aus Feuchttemperatur zum Beobachtungstermin II (13 UTC)'
    ),
    (
        'rfb_mittel', 
        '%', 
        'Relative Feuchte Mittelwert aus Feuchttemperatur', 
        'Relative Feuchte, Tagesmittel aus den berechneten Werten zu Beobachtungsterminen I,II,III (06,13,18 UTC)'
    ),
    (
        'rf_ii', 
        '%', 
        'Relative Feuchte zum Beobachtungstermin II', 
        'Relative Feuchte zum Beobachtungstermin II (13 UTC)'
    ),
    (
        'rf_mittel', 
        '%', 
        'Relative Feuchte Mittelwert', 
        'Relative Feuchte, Tagesmittel aus den Beobachtungsterminen I,II,III (06,13,18 UTC)'
    ),
    (
        'rr_iii', 
        'mm', 
        'Niederschlag 12h Summe zum Beobachtungstermin III', 
        'Niederschlag, 12-Stundensumme der Einminutenwerte von 06:01 UTC bis 18:00 UTC, -1=kein Niederschlag, 0=weniger als 1/10 mm'
    ),
    (
        'sh', 
        'cm', 
        'Gesamtschneehöhe, Schneepegelmessung', 
        'Gesamtschneehöhe, aus automatischer Schneepegelmessung, Offset korrigiert, zum Beobachtungstermin I (06 UTC), -1=kein Schnee'
    ),
    (
        'p_mittel', 
        'hPa', 
        'Luftdruck Mittelwert', 
        'Luftdruck, Tagesmittel aus den Beobachtungsterminen I,II,III (06,13,18 UTC)'
    )
ON CONFLICT (code) DO UPDATE SET
    units = EXCLUDED.units,
    name = EXCLUDED.name,
    description = EXCLUDED.description;
