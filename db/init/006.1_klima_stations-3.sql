BEGIN;
DO $$
DECLARE
    v_batch_count INT;
    v_total_count INT;
    v_combined_count INT;
    v_individual_count INT;
BEGIN
    
-- Batch 7 of Remaining INDIVIDUAL Stations (50 rows: IDs 11603 to 15412)
INSERT INTO public.klima_stations (
    station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
    valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
    (11603, 'INDIVIDUAL', 20, 'Ehrwald', 'Tirol', 'T', 47.40417, 10.92, 982, '2007-10-18T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (11700, 'INDIVIDUAL', 87, 'Seefeld', 'Tirol', 'T', 47.33333, 11.16667, 1200, '1948-05-01T00:00:00+00:00', '1994-04-30T00:00:00+00:00', false, false, false),
    (11705, 'INDIVIDUAL', 87, 'Seefeld', 'Tirol', 'T', 47.33333, 11.16667, 1200, '1994-05-01T00:00:00+00:00', '1997-05-31T00:00:00+00:00', false, false, false),
    (11706, 'INDIVIDUAL', 87, 'Seefeld', 'Tirol', 'T', 47.32478, 11.17542, 1181.9, '1997-05-15T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (11707, 'INDIVIDUAL', NULL, 'Seefeld', 'Tirol', 'T', 47.327778, 11.178333, 1198, '2014-12-01T00:00:00+00:00', '2025-05-13T00:00:00+00:00', false, false, false),
    (11800, 'INDIVIDUAL', 175, 'Innsbruck Flughafen', 'Tirol', 'T', 47.25888, 11.35528, 579, '1951-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, true, true),
    (11801, 'INDIVIDUAL', 39, 'Innsbruck Universität', 'Tirol', 'T', 47.260555, 11.385, 577, '1877-01-01T00:00:00+00:00', '1986-12-31T00:00:00+00:00', true, true, false),
    (11803, 'INDIVIDUAL', 39, 'Innsbruck Universität', 'Tirol', 'T', 47.25986, 11.38425, 578, '1986-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (11804, 'INDIVIDUAL', 175, 'Innsbruck Flughafen', 'Tirol', 'T', 47.25999, 11.35667, 578, '1992-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (11810, 'INDIVIDUAL', NULL, 'Hafelekar', 'Tirol', 'T', 47.316666, 11.383333, 2261, '1938-01-01T00:00:00+00:00', '1951-09-30T00:00:00+00:00', false, false, false),
    (11900, 'INDIVIDUAL', 42, 'Jenbach', 'Tirol', 'T', 47.383335, 11.75, 530, '1955-04-01T00:00:00+00:00', '1994-06-30T00:00:00+00:00', true, false, false),
    (11901, 'INDIVIDUAL', 42, 'Jenbach', 'Tirol', 'T', 47.38878, 11.75814, 529, '1994-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (11902, 'INDIVIDUAL', NULL, 'Rotholz', 'Tirol', 'T', 47.388611, 11.8, 543, '1936-01-01T00:00:00+00:00', '1954-04-30T00:00:00+00:00', false, false, false),
    (11903, 'INDIVIDUAL', NULL, 'Jenbach', 'Tirol', 'T', 47.389999, 11.755278, 530, '2009-01-01T00:00:00+00:00', '2024-04-30T00:00:00+00:00', false, false, false),
    (11910, 'INDIVIDUAL', NULL, 'Pertisau', 'Tirol', 'T', 47.443611, 11.701111, 936, '1951-05-01T00:00:00+00:00', '1987-12-31T00:00:00+00:00', false, false, false),
    (12000, 'INDIVIDUAL', 211, 'Rattenberg-Radfeld', 'Tirol', 'T', 47.433334, 11.9, 525, '1977-06-01T00:00:00+00:00', '1981-06-30T00:00:00+00:00', false, false, false),
    (12010, 'INDIVIDUAL', 211, 'Rattenberg-Radfeld', 'Tirol', 'T', 47.444721, 11.9, 514, '1986-05-01T00:00:00+00:00', '1995-12-31T00:00:00+00:00', false, false, false),
    (12015, 'INDIVIDUAL', NULL, 'Alpbach', 'Tirol', 'T', 47.39667, 11.93944, 929, '2007-11-27T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12016, 'INDIVIDUAL', NULL, 'Alpbach', 'Tirol', 'T', 47.39639, 11.94055, 930, '2009-01-01T00:00:00+00:00', '2026-06-16T00:00:00+00:00', false, false, false),
    (12020, 'INDIVIDUAL', NULL, 'Kaltenbach', 'Tirol', 'T', 47.298332, 11.875556, 560, '1993-05-17T00:00:00+00:00', '1995-12-31T00:00:00+00:00', false, false, false),
    (12200, 'INDIVIDUAL', 118, 'Kitzbühel', 'Tirol', 'T', 47.441666, 12.394444, 763, '1978-08-01T00:00:00+00:00', '2001-06-30T00:00:00+00:00', false, false, false),
    (12201, 'INDIVIDUAL', 118, 'Kitzbühel', 'Tirol', 'T', 47.459722, 12.358333, 791, '2001-07-01T00:00:00+00:00', '2016-06-13T00:00:00+00:00', false, false, false),
    (12202, 'INDIVIDUAL', 118, 'Kitzbühel', 'Tirol', 'T', 47.44722, 12.39417, 746.1, '2007-01-01T00:00:00+00:00', '2014-03-21T00:00:00+00:00', true, true, false),
    (12203, 'INDIVIDUAL', 118, 'Kitzbühel', 'Tirol', 'T', 47.44389, 12.38917, 772, '2014-11-18T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12205, 'INDIVIDUAL', NULL, 'Kitzbühler Horn', 'Tirol', 'T', 47.483334, 12.433333, 1970, '1957-06-07T00:00:00+00:00', '1966-07-31T00:00:00+00:00', false, false, false),
    (12206, 'INDIVIDUAL', 118, 'Kitzbühel', 'Tirol', 'T', 47.450001, 12.383333, 790, '1936-01-01T00:00:00+00:00', '1951-10-31T00:00:00+00:00', false, false, false),
    (12207, 'INDIVIDUAL', 118, 'Kitzbühel', 'Tirol', 'T', 47.466667, 12.366667, 783, '1957-06-07T00:00:00+00:00', '1974-10-31T00:00:00+00:00', true, false, false),
    (12208, 'INDIVIDUAL', NULL, 'Kitzbühel', 'Tirol', 'T', 47.4425, 12.39639, 757, '2016-06-07T00:00:00+00:00', '2019-12-01T00:00:00+00:00', false, false, false),
    (12210, 'INDIVIDUAL', 176, 'Hahnenkamm', 'Tirol', 'T', 47.43333, 12.36667, 1665, '1938-01-01T00:00:00+00:00', '1967-04-30T00:00:00+00:00', true, false, false),
    (12212, 'INDIVIDUAL', 176, 'Hahnenkamm-Ehrenbachhöhe', 'Tirol', 'T', 47.41667, 12.36667, 1760, '1968-08-01T00:00:00+00:00', '1975-05-31T00:00:00+00:00', true, false, false),
    (12215, 'INDIVIDUAL', 176, 'Hahnenkamm-Ehrenbachhöhe', 'Tirol', 'T', 47.41831, 12.35928, 1793.8, '1992-11-12T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12216, 'INDIVIDUAL', NULL, 'Hahnenkamm-Sonnenrast', 'Tirol', 'T', 47.409168, 12.359445, 1667, '2016-10-20T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (12220, 'INDIVIDUAL', 177, 'Uttendorf', 'Salzburg', 'SBG', 47.262779, 12.569167, 803, '1961-09-01T00:00:00+00:00', '2008-10-31T00:00:00+00:00', false, false, false),
    (12231, 'INDIVIDUAL', 195, 'Mittersill', 'Salzburg', 'SBG', 47.279167, 12.495833, 783, '2017-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12300, 'INDIVIDUAL', 83, 'Saalbach', 'Salzburg', 'SBG', 47.392223, 12.643056, 1022, '1975-11-01T00:00:00+00:00', '1992-05-31T00:00:00+00:00', true, false, false),
    (12301, 'INDIVIDUAL', 83, 'Saalbach', 'Salzburg', 'SBG', 47.37833, 12.68917, 1022, '1992-06-01T00:00:00+00:00', '2008-12-31T00:00:00+00:00', true, false, false),
    (12302, 'INDIVIDUAL', 83, 'Saalbach', 'Salzburg', 'SBG', 47.38789, 12.64844, 974.6, '2008-09-30T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12310, 'INDIVIDUAL', 85, 'Schmittenhöhe', 'Salzburg', 'SBG', 47.333332, 12.733334, 1964, '1895-07-01T00:00:00+00:00', '1982-03-31T00:00:00+00:00', true, false, false),
    (12311, 'INDIVIDUAL', 85, 'Schmittenhöhe', 'Salzburg', 'SBG', 47.32872, 12.73794, 1955.6, '1983-10-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12321, 'INDIVIDUAL', NULL, 'Sonnenalm', 'Salzburg', 'SBG', 47.333332, 12.766666, 1386, '1958-10-01T00:00:00+00:00', '1964-02-29T00:00:00+00:00', false, false, false),
    (12322, 'INDIVIDUAL', 113, 'Zell am See', 'Salzburg', 'SBG', 47.32667, 12.79528, 766, '1984-07-12T00:00:00+00:00', '2019-07-15T00:00:00+00:00', true, false, false),
    (12323, 'INDIVIDUAL', 113, 'Zell am See', 'Salzburg', 'SBG', 47.29, 12.78639, 754, '2019-07-16T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, false, true),
    (12350, 'INDIVIDUAL', 178, 'Hochfilzen', 'Tirol', 'T', 47.47306, 12.63222, 1000, '2001-09-01T00:00:00+00:00', '2004-12-31T00:00:00+00:00', false, false, false),
    (12351, 'INDIVIDUAL', 178, 'Hochfilzen', 'Tirol', 'T', 47.47028, 12.62111, 961.9, '2007-11-27T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12352, 'INDIVIDUAL', NULL, 'Hochfilzen', 'Tirol', 'T', 47.470276, 12.621111, 960, '2008-03-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (12410, 'INDIVIDUAL', 84, 'Saalfelden', 'Salzburg', 'SBG', 47.433334, 12.85, 818, '1968-06-01T00:00:00+00:00', '1978-10-31T00:00:00+00:00', false, false, false),
    (12411, 'INDIVIDUAL', 84, 'Saalfelden', 'Salzburg', 'SBG', 47.416668, 12.833333, 735, '1984-05-01T00:00:00+00:00', '1992-04-30T00:00:00+00:00', true, false, false),
    (12500, 'INDIVIDUAL', 14, 'Bischofshofen', 'Salzburg', 'SBG', 47.4, 13.21667, 550, '1980-06-01T00:00:00+00:00', '1990-03-31T00:00:00+00:00', true, false, false),
    (12501, 'INDIVIDUAL', 14, 'Bischofshofen', 'Salzburg', 'SBG', 47.416668, 13.216666, 556, '1936-01-01T00:00:00+00:00', '1962-12-31T00:00:00+00:00', false, false, false),
    (12503, 'INDIVIDUAL', 14, 'Bischofshofen', 'Salzburg', 'SBG', 47.40806, 13.22389, 550, '1990-02-01T00:00:00+00:00', '1996-08-31T00:00:00+00:00', true, false, false)
ON CONFLICT (station_id) DO UPDATE SET
    type = EXCLUDED.type, group_id = EXCLUDED.group_id, name = EXCLUDED.name,
    state = EXCLUDED.state, bundesland_code = EXCLUDED.bundesland_code,
    lat = EXCLUDED.lat, lon = EXCLUDED.lon, altitude = EXCLUDED.altitude,
    valid_from = EXCLUDED.valid_from, valid_to = EXCLUDED.valid_to,
    has_sunshine = EXCLUDED.has_sunshine, has_global_radiation = EXCLUDED.has_global_radiation,
    is_active = EXCLUDED.is_active;

-- Batch 8 of Remaining INDIVIDUAL Stations (50 rows: IDs 12504 to 15721)
INSERT INTO public.klima_stations (
    station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
    valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
    (12504, 'INDIVIDUAL', 14, 'Bischofshofen', 'Salzburg', 'SBG', 47.40667, 13.22111, 549.9, '1996-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12505, 'INDIVIDUAL', 156, 'St. Johann im Pongau', 'Salzburg', 'SBG', 47.31528, 13.18361, 634, '1985-01-01T00:00:00+00:00', '2008-02-29T00:00:00+00:00', true, false, true),
    (12506, 'INDIVIDUAL', NULL, 'Bischofshofen-Buchberg', 'Salzburg', 'SBG', 47.400002, 13.216666, 733, '2001-01-01T00:00:00+00:00', '2026-06-16T00:00:00+00:00', false, false, false),
    (12510, 'INDIVIDUAL', NULL, 'Schwarzach', 'Salzburg', 'SBG', 47.316666, 13.133333, 600, '1963-04-01T00:00:00+00:00', '1989-06-30T00:00:00+00:00', false, false, false),
    (12513, 'INDIVIDUAL', NULL, 'St. Veit im Pongau', 'Salzburg', 'SBG', 47.32917, 13.155, 749, '1984-11-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12520, 'INDIVIDUAL', NULL, 'Mitterberg', 'Salzburg', 'SBG', 47.416668, 13.133333, 1503, '1948-01-01T00:00:00+00:00', '1975-12-31T00:00:00+00:00', false, false, false),
    (12530, 'INDIVIDUAL', 156, 'St. Johann im Pongau', 'Salzburg', 'SBG', 47.31981, 13.18672, 634.2, '2008-03-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (12607, 'INDIVIDUAL', 73, 'Radstadt-Löbenau', 'Salzburg', 'SBG', 47.383335, 13.45, 846, '1961-06-01T00:00:00+00:00', '1963-03-31T00:00:00+00:00', false, false, false),
    (12608, 'INDIVIDUAL', 73, 'Radstadt', 'Salzburg', 'SBG', 47.383335, 13.45, 846, '1936-01-01T00:00:00+00:00', '1945-01-31T00:00:00+00:00', false, false, false),
    (12609, 'INDIVIDUAL', 73, 'Radstadt', 'Salzburg', 'SBG', 47.383335, 13.466666, 880, '1948-01-01T00:00:00+00:00', '1961-05-31T00:00:00+00:00', false, false, false),
    (12610, 'INDIVIDUAL', 73, 'Radstadt', 'Salzburg', 'SBG', 47.38333, 13.45, 845, '1964-11-01T00:00:00+00:00', '1994-12-31T00:00:00+00:00', true, false, false),
    (12615, 'INDIVIDUAL', 73, 'Radstadt', 'Salzburg', 'SBG', 47.38528, 13.45611, 858, '1994-07-01T00:00:00+00:00', '2017-11-08T00:00:00+00:00', true, true, false),
    (12616, 'INDIVIDUAL', 73, 'Radstadt-Tandalier', 'Salzburg', 'SBG', 47.38, 13.44083, 835, '2016-08-08T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12620, 'INDIVIDUAL', NULL, 'Wagrain', 'Salzburg', 'SBG', 47.333611, 13.305, 880, '1988-12-01T00:00:00+00:00', '1999-11-30T00:00:00+00:00', false, false, false),
    (12700, 'INDIVIDUAL', NULL, 'Rohrmoos', 'Steiermark', 'STMK', 47.378334, 13.659166, 1075, '1981-01-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', true, false, false),
    (12711, 'INDIVIDUAL', 179, 'Ramsau am Dachstein', 'Steiermark', 'STMK', 47.42514, 13.63428, 1206.8, '1991-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12720, 'INDIVIDUAL', NULL, 'Dachstein-Hunerkogel', 'Oberösterreich', 'OOE', 47.46778, 13.62639, 2700, '2017-05-29T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (12721, 'INDIVIDUAL', NULL, 'Dachstein-Schladminger Gletscher', 'Oberösterreich', 'OOE', 47.474445, 13.6325, 2520, '2017-11-13T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (12800, 'INDIVIDUAL', NULL, 'Kleinsölk', 'Steiermark', 'STMK', 47.400002, 13.933333, 1005, '1971-01-01T00:00:00+00:00', '1995-09-30T00:00:00+00:00', false, false, false),
    (12805, 'INDIVIDUAL', NULL, 'St. Nikolai', 'Steiermark', 'STMK', 47.316666, 14.05, 1110, '1966-11-01T00:00:00+00:00', '1969-04-30T00:00:00+00:00', false, false, false),
    (12810, 'INDIVIDUAL', 147, 'Gröbming', 'Steiermark', 'STMK', 47.44556, 13.90361, 766, '1981-08-01T00:00:00+00:00', '1999-07-31T00:00:00+00:00', true, true, false),
    (12811, 'INDIVIDUAL', 147, 'Gröbming', 'Steiermark', 'STMK', 47.44678, 13.90422, 765.5, '2001-10-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13000, 'INDIVIDUAL', NULL, 'Oberzeiring', 'Steiermark', 'STMK', 47.254723, 14.496111, 933, '1971-01-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', true, false, false),
    (13010, 'INDIVIDUAL', NULL, 'Pusterwald', 'Steiermark', 'STMK', 47.308056, 14.375278, 1070, '1978-01-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', false, false, false),
    (13020, 'INDIVIDUAL', NULL, 'Trieben', 'Steiermark', 'STMK', 47.483334, 14.5, 708, '1936-01-01T00:00:00+00:00', '1985-12-31T00:00:00+00:00', false, false, false),
    (13100, 'INDIVIDUAL', 44, 'Kalwang', 'Steiermark', 'STMK', 47.416668, 14.733334, 753, '1966-12-01T00:00:00+00:00', '1989-02-28T00:00:00+00:00', false, false, false),
    (13110, 'INDIVIDUAL', 124, 'Seckau', 'Steiermark', 'STMK', 47.283333, 14.783334, 874, '1895-01-01T00:00:00+00:00', '1996-06-30T00:00:00+00:00', false, false, false),
    (13115, 'INDIVIDUAL', 124, 'Seckau', 'Steiermark', 'STMK', 47.270557, 14.778611, 855, '1999-06-01T00:00:00+00:00', '2002-01-31T00:00:00+00:00', false, false, false),
    (13116, 'INDIVIDUAL', 124, 'Seckau', 'Steiermark', 'STMK', 47.27083, 14.77861, 872, '2002-02-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13120, 'INDIVIDUAL', 44, 'Kalwang', 'Steiermark', 'STMK', 47.42126, 14.75961, 743.6, '1994-04-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13250, 'INDIVIDUAL', NULL, 'St. Michael bei Leoben', 'Steiermark', 'STMK', 47.335556, 15.005, 570, '1984-09-01T00:00:00+00:00', '2013-05-14T00:00:00+00:00', true, true, false),
    (13300, 'INDIVIDUAL', 17, 'Bruck an der Mur', 'Steiermark', 'STMK', 47.41667, 15.26667, 489, '1895-01-01T00:00:00+00:00', '1984-12-31T00:00:00+00:00', true, false, false),
    (13301, 'INDIVIDUAL', 17, 'Bruck an der Mur', 'Steiermark', 'STMK', 47.40583, 15.25111, 480, '1985-01-01T00:00:00+00:00', '2004-12-31T00:00:00+00:00', false, false, false),
    (13302, 'INDIVIDUAL', 17, 'Bruck an der Mur', 'Steiermark', 'STMK', 47.40556, 15.24972, 482, '2004-12-01T00:00:00+00:00', '2025-11-11T00:00:00+00:00', true, true, false),
    (13303, 'INDIVIDUAL', 17, 'Bruck an der Mur / Oberdorf', 'Steiermark', 'STMK', 47.403056, 15.233611, 489, '2025-11-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13305, 'INDIVIDUAL', 217, 'Kapfenberg', 'Steiermark', 'STMK', 47.44592, 15.29828, 504.7, '1997-03-01T00:00:00+00:00', '2018-05-22T00:00:00+00:00', true, true, false),
    (13308, 'INDIVIDUAL', NULL, 'Frohnleiten', 'Steiermark', 'STMK', 47.25556, 15.315, 421, '2008-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13312, 'INDIVIDUAL', NULL, 'Leoben', 'Steiermark', 'STMK', 47.37833, 15.08667, 544, '2012-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13400, 'INDIVIDUAL', NULL, 'Rechberg', 'Steiermark', 'STMK', 47.262779, 15.416389, 926, '1968-04-17T00:00:00+00:00', '2007-12-31T00:00:00+00:00', true, false, false),
    (13401, 'INDIVIDUAL', 217, 'Kapfenberg Flugfeld', 'Steiermark', 'STMK', 47.45833, 15.33556, 515, '2018-05-23T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13500, 'INDIVIDUAL', NULL, 'Birkfeld', 'Steiermark', 'STMK', 47.366665, 15.683333, 623, '1941-10-01T00:00:00+00:00', '1991-12-31T00:00:00+00:00', true, false, false),
    (13510, 'INDIVIDUAL', 25, 'Fischbach', 'Steiermark', 'STMK', 47.447224, 15.6725, 1020, '1980-10-01T00:00:00+00:00', '1995-12-31T00:00:00+00:00', false, false, false),
    (13515, 'INDIVIDUAL', 25, 'Fischbach', 'Steiermark', 'STMK', 47.44417, 15.64389, 1034.4, '1995-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13600, 'INDIVIDUAL', NULL, 'Altenberg/Hartberg', 'Steiermark', 'STMK', 47.256668, 16.031389, 429, '1980-04-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', false, false, false),
    (13605, 'INDIVIDUAL', NULL, 'Hartberg', 'Steiermark', 'STMK', 47.28056, 15.97861, 329.6, '1994-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13606, 'INDIVIDUAL', NULL, 'Rohrbach an der Lafnitz/Eichberg', 'Steiermark', 'STMK', 47.4, 15.93694, 692, '2009-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13640, 'INDIVIDUAL', NULL, 'Kroisegg', 'Burgenland', 'BGLD', 47.378613, 16.042223, 444, '2016-06-07T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (13700, 'INDIVIDUAL', 13, 'Bernstein', 'Burgenland', 'BGLD', 47.400002, 16.25, 615, '1949-11-01T00:00:00+00:00', '1990-02-28T00:00:00+00:00', false, false, false),
    (13701, 'INDIVIDUAL', 13, 'Bernstein', 'Burgenland', 'BGLD', 47.405277, 16.260555, 600, '1990-03-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', false, false, false),
    (13702, 'INDIVIDUAL', 13, 'Bernstein', 'Burgenland', 'BGLD', 47.40833, 16.26139, 630.8, '2007-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true)
ON CONFLICT (station_id) DO UPDATE SET
    type = EXCLUDED.type, group_id = EXCLUDED.group_id, name = EXCLUDED.name,
    state = EXCLUDED.state, bundesland_code = EXCLUDED.bundesland_code,
    lat = EXCLUDED.lat, lon = EXCLUDED.lon, altitude = EXCLUDED.altitude,
    valid_from = EXCLUDED.valid_from, valid_to = EXCLUDED.valid_to,
    has_sunshine = EXCLUDED.has_sunshine, has_global_radiation = EXCLUDED.has_global_radiation,
    is_active = EXCLUDED.is_active;

-- Batch 9 of Remaining INDIVIDUAL Stations (50 rows: IDs 13706 to 18621)
INSERT INTO public.klima_stations (
    station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
    valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
    (13706, 'INDIVIDUAL', 140, 'Bad Tatzmannsdorf', 'Burgenland', 'BGLD', 47.33797, 16.225, 347.2, '2004-09-17T00:00:00+00:00', '2024-01-31T00:00:00+00:00', true, false, false),
    (13707, 'INDIVIDUAL', 140, 'Bad Tatzmannsdorf', 'Burgenland', 'BGLD', 47.328056, 16.228056, 332, '2024-01-24T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, false, true),
    (13800, 'INDIVIDUAL', NULL, 'Glashütten', 'Burgenland', 'BGLD', 47.382221, 16.383888, 421, '1973-07-01T00:00:00+00:00', '1995-12-31T00:00:00+00:00', true, false, false),
    (13805, 'INDIVIDUAL', NULL, 'Hirschenstein', 'Burgenland', 'BGLD', 47.345276, 16.379168, 858.9, '2007-02-14T00:00:00+00:00', '2014-09-16T00:00:00+00:00', true, true, false),
    (13811, 'INDIVIDUAL', 180, 'Rechnitz', 'Burgenland', 'BGLD', 47.30139, 16.45417, 308, '2006-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, false, true),
    (13905, 'INDIVIDUAL', 58, 'Lutzmannsburg', 'Burgenland', 'BGLD', 47.465, 16.661388, 198, '1995-01-01T00:00:00+00:00', '1996-01-31T00:00:00+00:00', false, false, false),
    (13906, 'INDIVIDUAL', 58, 'Lutzmannsburg', 'Burgenland', 'BGLD', 47.46417, 16.66056, 201, '1995-10-08T00:00:00+00:00', '2000-05-31T00:00:00+00:00', true, false, false),
    (13907, 'INDIVIDUAL', 58, 'Lutzmannsburg', 'Burgenland', 'BGLD', 47.46528, 16.64556, 200.8, '2000-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14100, 'INDIVIDUAL', NULL, 'Bürs', 'Vorarlberg', 'VBG', 47.141453, 9.811217, 567, '1965-05-01T00:00:00+00:00', '2001-10-31T00:00:00+00:00', false, false, false),
    (14103, 'INDIVIDUAL', 181, 'Bludenz', 'Vorarlberg', 'VBG', 47.14778, 9.82944, 571, '2015-09-15T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14104, 'INDIVIDUAL', 181, 'Bludenz', 'Vorarlberg', 'VBG', 47.154167, 9.823611, 564.8, '2007-08-01T00:00:00+00:00', '2015-09-09T00:00:00+00:00', true, true, false),
    (14105, 'INDIVIDUAL', 181, 'Bludenz', 'Vorarlberg', 'VBG', 47.142222, 9.835834, 575, '2001-08-17T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (14106, 'INDIVIDUAL', 181, 'Bludenz', 'Vorarlberg', 'VBG', 47.150002, 9.833333, 570, '1936-01-01T00:00:00+00:00', '1940-03-31T00:00:00+00:00', false, false, false),
    (14107, 'INDIVIDUAL', 181, 'Bludenz', 'Vorarlberg', 'VBG', 47.166668, 9.816667, 598, '1943-01-01T00:00:00+00:00', '1945-02-28T00:00:00+00:00', false, false, false),
    (14108, 'INDIVIDUAL', 181, 'Bludenz', 'Vorarlberg', 'VBG', 47.166668, 9.816667, 599, '1947-09-01T00:00:00+00:00', '1950-06-30T00:00:00+00:00', false, false, false),
    (14109, 'INDIVIDUAL', 181, 'Bludenz', 'Vorarlberg', 'VBG', 47.166668, 9.816667, 567, '1950-07-01T00:00:00+00:00', '1964-07-31T00:00:00+00:00', false, false, false),
    (14110, 'INDIVIDUAL', NULL, 'Laz', 'Vorarlberg', 'VBG', 47.183334, 9.816667, 900, '1976-07-01T00:00:00+00:00', '1990-03-31T00:00:00+00:00', false, false, false),
    (14111, 'INDIVIDUAL', NULL, 'Muttersberg/Madeisa', 'Vorarlberg', 'VBG', 47.180557, 9.825277, 1384, '1990-04-01T00:00:00+00:00', '1992-08-31T00:00:00+00:00', false, false, false),
    (14115, 'INDIVIDUAL', NULL, 'Brand', 'Vorarlberg', 'VBG', 47.10306, 9.73833, 1029, '2001-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14130, 'INDIVIDUAL', NULL, 'Muttersberg', 'Vorarlberg', 'VBG', 47.180557, 9.825277, 1384, '1959-10-01T00:00:00+00:00', '1972-03-31T00:00:00+00:00', false, false, false),
    (14135, 'INDIVIDUAL', NULL, 'Schlins', 'Vorarlberg', 'VBG', 47.200001, 9.7, 519, '1963-02-19T00:00:00+00:00', '1974-06-30T00:00:00+00:00', false, false, false),
    (14150, 'INDIVIDUAL', NULL, 'Bludenz Bleiche', 'Vorarlberg', 'VBG', 47.166668, 9.8, 580, '1995-01-01T00:00:00+00:00', '1996-12-31T00:00:00+00:00', false, false, false),
    (14200, 'INDIVIDUAL', NULL, 'Vandans', 'Vorarlberg', 'VBG', 47.089443, 9.864445, 670, '1977-07-01T00:00:00+00:00', '2008-05-31T00:00:00+00:00', true, true, false),
    (14300, 'INDIVIDUAL', 119, 'St. Anton am Arlberg', 'Tirol', 'T', 47.13611, 10.27028, 1298, '1957-01-01T00:00:00+00:00', '2002-03-31T00:00:00+00:00', false, false, false),
    (14301, 'INDIVIDUAL', 119, 'St. Anton am Arlberg', 'Tirol', 'T', 47.13167, 10.27, 1289, '2002-04-01T00:00:00+00:00', '2025-05-31T00:00:00+00:00', false, false, false),
    (14302, 'INDIVIDUAL', 119, 'St. Anton am Arlberg', 'Tirol', 'T', 47.13139, 10.26667, 1304.1, '2007-08-03T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14303, 'INDIVIDUAL', 119, 'St. Anton am Arlberg', 'Tirol', 'T', 47.133335, 10.266666, 1305, '1938-02-01T00:00:00+00:00', '1943-02-28T00:00:00+00:00', false, false, false),
    (14304, 'INDIVIDUAL', 119, 'St. Anton am Arlberg', 'Tirol', 'T', 47.133335, 10.266666, 1350, '1946-01-15T00:00:00+00:00', '1950-12-31T00:00:00+00:00', false, false, false),
    (14305, 'INDIVIDUAL', NULL, 'Galzig', 'Tirol', 'T', 47.12972, 10.23028, 2079, '1993-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14308, 'INDIVIDUAL', NULL, 'Valluga', 'Tirol', 'T', 47.1575, 10.21278, 2805, '2011-02-14T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (14310, 'INDIVIDUAL', NULL, 'Langen am Arlberg', 'Vorarlberg', 'VBG', 47.134998, 10.124722, 1270, '1895-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (14311, 'INDIVIDUAL', NULL, 'Langen am Arlberg', 'Vorarlberg', 'VBG', 47.13167, 10.12333, 1221, '2007-08-06T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14400, 'INDIVIDUAL', 50, 'Landeck', 'Tirol', 'T', 47.13333, 10.56667, 818, '1946-02-01T00:00:00+00:00', '1986-04-30T00:00:00+00:00', false, false, false),
    (14401, 'INDIVIDUAL', 50, 'Landeck', 'Tirol', 'T', 47.13333, 10.56667, 785, '1986-01-01T00:00:00+00:00', '1993-06-30T00:00:00+00:00', true, true, false),
    (14403, 'INDIVIDUAL', 50, 'Landeck', 'Tirol', 'T', 47.14025, 10.56364, 795.6, '1993-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14500, 'INDIVIDUAL', NULL, 'Hochserfaus', 'Tirol', 'T', 47.033333, 10.6, 1815, '1935-01-01T00:00:00+00:00', '1988-12-31T00:00:00+00:00', true, true, false),
    (14510, 'INDIVIDUAL', 38, 'Imst', 'Tirol', 'T', 47.236111, 10.741667, 785, '1936-01-01T00:00:00+00:00', '1983-05-31T00:00:00+00:00', true, false, false),
    (14511, 'INDIVIDUAL', 38, 'Imst', 'Tirol', 'T', 47.23111, 10.729722, 910, '1984-01-01T00:00:00+00:00', '1987-05-16T00:00:00+00:00', false, false, false),
    (14512, 'INDIVIDUAL', 38, 'Imst', 'Tirol', 'T', 47.24889, 10.741111, 860, '1987-12-17T00:00:00+00:00', '2024-10-08T00:00:00+00:00', false, false, false),
    (14513, 'INDIVIDUAL', 38, 'Imst', 'Tirol', 'T', 47.23694, 10.74222, 773, '2007-08-17T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14515, 'INDIVIDUAL', NULL, 'Ried in Tirol', 'Tirol', 'T', 47.049999, 10.65, 826, '1933-10-01T00:00:00+00:00', '1945-02-28T00:00:00+00:00', false, false, false),
    (14520, 'INDIVIDUAL', 138, 'Prutz', 'Tirol', 'T', 47.066666, 10.666667, 870, '1967-07-01T00:00:00+00:00', '2005-02-28T00:00:00+00:00', true, false, false),
    (14521, 'INDIVIDUAL', 138, 'Prutz', 'Tirol', 'T', 47.06861, 10.66472, 871, '2004-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14600, 'INDIVIDUAL', 126, 'Haiming', 'Tirol', 'T', 47.25, 10.85, 695, '1965-09-01T00:00:00+00:00', '2000-05-31T00:00:00+00:00', false, false, false),
    (14602, 'INDIVIDUAL', 126, 'Haiming', 'Tirol', 'T', 47.25861, 10.879167, 663, '2000-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (14603, 'INDIVIDUAL', 126, 'Haiming', 'Tirol', 'T', 47.25972, 10.88944, 659, '2007-08-19T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14605, 'INDIVIDUAL', 126, 'Haiming', 'Tirol', 'T', 47.266666, 10.866667, 660, '1947-11-01T00:00:00+00:00', '1957-04-30T00:00:00+00:00', false, false, false),
    (14610, 'INDIVIDUAL', NULL, 'Kühtai', 'Tirol', 'T', 47.208332, 11.013333, 1970, '1976-06-01T00:00:00+00:00', '1999-12-31T00:00:00+00:00', false, false, false),
    (14620, 'INDIVIDUAL', 210, 'Pioesmes', 'Tirol', 'T', 47.049999, 10.866667, 1410, '1967-01-01T00:00:00+00:00', '1982-12-31T00:00:00+00:00', true, false, false),
    (14621, 'INDIVIDUAL', 210, 'St. Leonhard-Neurur', 'Tirol', 'T', 47.022221, 10.864445, 1462, '1983-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true)
ON CONFLICT (station_id) DO UPDATE SET
    type = EXCLUDED.type, group_id = EXCLUDED.group_id, name = EXCLUDED.name,
    state = EXCLUDED.state, bundesland_code = EXCLUDED.bundesland_code,
    lat = EXCLUDED.lat, lon = EXCLUDED.lon, altitude = EXCLUDED.altitude,
    valid_from = EXCLUDED.valid_from, valid_to = EXCLUDED.valid_to,
    has_sunshine = EXCLUDED.has_sunshine, has_global_radiation = EXCLUDED.has_global_radiation,
    is_active = EXCLUDED.is_active;

   -- Capture how many rows the INSERT just processed
    GET DIAGNOSTICS v_batch_count = ROW_COUNT;

    -- Query current totals in the table
    SELECT 
        COUNT(*),
        COUNT(*) FILTER (WHERE type = 'COMBINED'),
        COUNT(*) FILTER (WHERE type = 'INDIVIDUAL')
    INTO v_total_count, v_combined_count, v_individual_count
    FROM public.klima_stations;

    -- Print summary to the Messages tab
    RAISE NOTICE '006.1_klima_stations-3.sql: Last batch processed: % rows | Table public.klima_stations total: % (% COMBINED, % INDIVIDUAL)', 
        v_batch_count, v_total_count, v_combined_count, v_individual_count;
END $$;

COMMIT;