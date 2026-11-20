BEGIN;
DO $$
DECLARE
    v_batch_count INT;
    v_total_count INT;
    v_combined_count INT;
    v_individual_count INT;
BEGIN

-- Batch 10: INDIVIDUAL Stations (50 rows: IDs 14622 to 18402)
INSERT INTO public.klima_stations (
    station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
    valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
    (14622, 'INDIVIDUAL', 210, 'St. Leonhard im Pitztal', 'Tirol', 'T', 47.02722, 10.86556, 1454.4, '2007-11-27T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14630, 'INDIVIDUAL', 136, 'Umhausen', 'Tirol', 'T', 47.137501, 10.933888, 1041, '1936-01-01T00:00:00+00:00', '2003-09-30T00:00:00+00:00', true, false, false),
    (14631, 'INDIVIDUAL', 136, 'Umhausen', 'Tirol', 'T', 47.13917, 10.92889, 1035, '2003-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14701, 'INDIVIDUAL', NULL, 'Neustift/Milders', 'Tirol', 'T', 47.10278, 11.29194, 1006.6, '2004-11-06T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14800, 'INDIVIDUAL', 16, 'Brenner', 'Tirol', 'T', 47, 11.516666, 1450, '1948-01-01T00:00:00+00:00', '1992-12-31T00:00:00+00:00', false, false, false),
    (14801, 'INDIVIDUAL', 16, 'Brenner', 'Tirol', 'T', 47.005554, 11.513333, 1445, '1992-10-01T00:00:00+00:00', '2015-01-31T00:00:00+00:00', true, true, false),
    (14802, 'INDIVIDUAL', 16, 'Brenner', 'Tirol', 'T', 47.00722, 11.51083, 1412, '2007-11-27T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14806, 'INDIVIDUAL', 196, 'Patscherkofel', 'Tirol', 'T', 47.216667, 11.45, 1970, '1940-08-01T00:00:00+00:00', '1946-05-31T00:00:00+00:00', true, false, false),
    (14807, 'INDIVIDUAL', 196, 'Patscherkofel', 'Tirol', 'T', 47.216667, 11.459444, 2050, '1946-06-01T00:00:00+00:00', '1954-12-31T00:00:00+00:00', true, false, false),
    (14808, 'INDIVIDUAL', 196, 'Patscherkofel', 'Tirol', 'T', 47.200001, 11.45, 1905, '1955-01-01T00:00:00+00:00', '1958-01-16T00:00:00+00:00', true, false, false),
    (14809, 'INDIVIDUAL', 196, 'Patscherkofel', 'Tirol', 'T', 47.200001, 11.45, 2045, '1958-01-17T00:00:00+00:00', '1966-12-15T00:00:00+00:00', true, false, false),
    (14810, 'INDIVIDUAL', 196, 'Patscherkofel', 'Tirol', 'T', 47.209446, 11.462222, 2247, '1966-12-16T00:00:00+00:00', '2010-09-30T00:00:00+00:00', true, false, false),
    (14812, 'INDIVIDUAL', 196, 'Patscherkofel', 'Tirol', 'T', 47.20889, 11.46222, 2251, '1993-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14820, 'INDIVIDUAL', 127, 'Rinn', 'Tirol', 'T', 47.24889, 11.484445, 900, '1957-01-01T00:00:00+00:00', '2000-03-31T00:00:00+00:00', true, true, false),
    (14821, 'INDIVIDUAL', 127, 'Rinn', 'Tirol', 'T', 47.25, 11.501667, 895, '2000-04-01T00:00:00+00:00', '2025-09-01T00:00:00+00:00', false, false, false),
    (14822, 'INDIVIDUAL', 127, 'Rinn', 'Tirol', 'T', 47.24917, 11.50389, 924.1, '2007-11-27T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14825, 'INDIVIDUAL', NULL, 'Schmirn', 'Tirol', 'T', 47.08722, 11.58028, 1464, '2004-11-06T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14833, 'INDIVIDUAL', 139, 'Steinach am Brenner', 'Tirol', 'T', 47.09833, 11.46611, 1036, '2007-11-27T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (14834, 'INDIVIDUAL', NULL, 'Steinach in Tirol', 'Tirol', 'T', 47.083332, 11.466666, 1025, '2009-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (14912, 'INDIVIDUAL', NULL, 'Hintertux', 'Tirol', 'T', 47.10694, 11.675, 1505, '2013-02-22T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, false, true),
    (15000, 'INDIVIDUAL', 61, 'Mayrhofen', 'Tirol', 'T', 47.150002, 11.85, 643, '1936-01-01T00:00:00+00:00', '1992-09-30T00:00:00+00:00', false, false, false),
    (15001, 'INDIVIDUAL', 61, 'Mayrhofen', 'Tirol', 'T', 47.159443, 11.850555, 643, '1992-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15002, 'INDIVIDUAL', 61, 'Mayrhofen', 'Tirol', 'T', 47.1625, 11.85139, 640, '2007-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15010, 'INDIVIDUAL', 114, 'Zell am Ziller', 'Tirol', 'T', 47.233334, 11.897778, 585, '1955-09-01T00:00:00+00:00', '1985-12-31T00:00:00+00:00', true, false, false),
    (15011, 'INDIVIDUAL', 114, 'Zell am Ziller/Rohrberg', 'Tirol', 'T', 47.255001, 11.904722, 595, '1986-02-01T00:00:00+00:00', '1993-01-31T00:00:00+00:00', false, false, false),
    (15100, 'INDIVIDUAL', 47, 'Krimml', 'Salzburg', 'SBG', 47.23333, 12.18333, 1062, '1953-06-15T00:00:00+00:00', '1979-09-30T00:00:00+00:00', false, false, false),
    (15101, 'INDIVIDUAL', 47, 'Krimml', 'Salzburg', 'SBG', 47.23, 12.18333, 1000, '1983-11-17T00:00:00+00:00', '1997-08-31T00:00:00+00:00', true, false, false),
    (15105, 'INDIVIDUAL', 47, 'Krimml', 'Salzburg', 'SBG', 47.22911, 12.18197, 1008.8, '1997-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15210, 'INDIVIDUAL', NULL, 'Virgen', 'Tirol', 'T', 47.00278, 12.45592, 1211.9, '1992-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15300, 'INDIVIDUAL', NULL, 'Enzingerboden', 'Salzburg', 'SBG', 47.166667, 12.633333, 1480, '1962-03-01T00:00:00+00:00', '2026-06-16T00:00:00+00:00', false, false, false),
    (15310, 'INDIVIDUAL', NULL, 'Mooserboden', 'Salzburg', 'SBG', 47.150002, 12.716666, 2036, '1944-09-01T00:00:00+00:00', '2008-06-30T00:00:00+00:00', true, false, false),
    (15320, 'INDIVIDUAL', 82, 'Rudolfshütte', 'Salzburg', 'SBG', 47.13333, 12.61667, 2304, '1980-06-01T00:00:00+00:00', '1992-11-30T00:00:00+00:00', true, false, false),
    (15321, 'INDIVIDUAL', 82, 'Rudolfshütte', 'Salzburg', 'SBG', 47.13492, 12.62594, 2317, '1992-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15322, 'INDIVIDUAL', 82, 'Rudolfshütte Weißsee', 'Salzburg', 'SBG', 47.133335, 12.633333, 2315, '1961-08-01T00:00:00+00:00', '1978-04-30T00:00:00+00:00', false, false, false),
    (15330, 'INDIVIDUAL', NULL, 'Schneiderau', 'Salzburg', 'SBG', 47.200001, 12.6, 1041, '1961-06-01T00:00:00+00:00', '1980-12-31T00:00:00+00:00', false, false, false),
    (15340, 'INDIVIDUAL', 43, 'Kals', 'Tirol', 'T', 47, 12.65, 1347, '1951-05-01T00:00:00+00:00', '1984-06-30T00:00:00+00:00', false, false, false),
    (15341, 'INDIVIDUAL', 43, 'Kals/Großdorf', 'Tirol', 'T', 47, 12.633333, 1350, '1984-07-01T00:00:00+00:00', '1993-04-30T00:00:00+00:00', false, false, false),
    (15343, 'INDIVIDUAL', 43, 'Kals', 'Tirol', 'T', 47.003334, 12.646111, 1338, '1993-04-30T00:00:00+00:00', '2007-12-31T00:00:00+00:00', false, false, false),
    (15344, 'INDIVIDUAL', 43, 'Kals', 'Tirol', 'T', 47.00478, 12.6465, 1352.4, '2007-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15400, 'INDIVIDUAL', 78, 'Rauris', 'Salzburg', 'SBG', 47.216667, 13, 945, '1946-04-01T00:00:00+00:00', '1989-06-30T00:00:00+00:00', true, false, false),
    (15401, 'INDIVIDUAL', 78, 'Rauris', 'Salzburg', 'SBG', 47.25, 12.983334, 916, '1989-07-01T00:00:00+00:00', '1993-12-31T00:00:00+00:00', true, false, false),
    (15402, 'INDIVIDUAL', 78, 'Rauris', 'Salzburg', 'SBG', 47.22353, 12.99262, 933.8, '1992-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15403, 'INDIVIDUAL', 78, 'Rauris', 'Salzburg', 'SBG', 47.233334, 13, 943, '1875-09-01T00:00:00+00:00', '1946-11-30T00:00:00+00:00', false, false, false),
    (15410, 'INDIVIDUAL', 213, 'Sonnblick', 'Salzburg', 'SBG', 47.05417, 12.9575, 3109, '1886-10-01T00:00:00+00:00', '2008-12-31T00:00:00+00:00', true, true, false),
    (15411, 'INDIVIDUAL', 213, 'Sonnblick', 'Salzburg', 'SBG', 47.05417, 12.9575, 3109, '1986-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15412, 'INDIVIDUAL', NULL, 'Sonnblick Fensterhütte', 'Salzburg', 'SBG', 47.055, 12.958055, 3105, '1996-10-01T00:00:00+00:00', '2001-10-31T00:00:00+00:00', true, false, false),
    (15420, 'INDIVIDUAL', 34, 'Heiligenblut', 'Kärnten', 'K', 47.033333, 12.847222, 1242, '1977-10-01T00:00:00+00:00', '1997-03-31T00:00:00+00:00', true, false, false),
    (15421, 'INDIVIDUAL', 34, 'Heiligenblut', 'Kärnten', 'K', 47.036388, 12.8525, 1315, '1997-07-01T00:00:00+00:00', '1999-12-31T00:00:00+00:00', false, false, false),
    (15430, 'INDIVIDUAL', NULL, 'Kolm-Saigurn', 'Salzburg', 'SBG', 47.06944, 12.98472, 1626.2, '1995-11-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15500, 'INDIVIDUAL', 7, 'Bad Gastein', 'Salzburg', 'SBG', 47.116665, 13.133333, 1100, '1976-07-01T00:00:00+00:00', '1995-10-31T00:00:00+00:00', true, false, false)
ON CONFLICT (station_id) DO UPDATE SET
    type = EXCLUDED.type, group_id = EXCLUDED.group_id, name = EXCLUDED.name,
    state = EXCLUDED.state, bundesland_code = EXCLUDED.bundesland_code,
    lat = EXCLUDED.lat, lon = EXCLUDED.lon, altitude = EXCLUDED.altitude,
    valid_from = EXCLUDED.valid_from, valid_to = EXCLUDED.valid_to,
    has_sunshine = EXCLUDED.has_sunshine, has_global_radiation = EXCLUDED.has_global_radiation,
    is_active = EXCLUDED.is_active;

-- Batch 11: Final INDIVIDUAL Stations (58 rows: IDs 15501 to 21302)
-- Final Batch of INDIVIDUAL Stations (58 rows: IDs 15501 to 21302)
INSERT INTO public.klima_stations (
    station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
    valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
    (15501, 'INDIVIDUAL', 7, 'Bad Gastein', 'Salzburg', 'SBG', 47.11056, 13.13336, 1092, '2009-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15504, 'INDIVIDUAL', 7, 'Bad Gastein', 'Salzburg', 'SBG', 47.116665, 13.133333, 1082, '1926-04-21T00:00:00+00:00', '1975-12-31T00:00:00+00:00', true, false, false),
    (15505, 'INDIVIDUAL', NULL, 'Bad Hofgastein', 'Salzburg', 'SBG', 47.171944, 13.105556, 850, '1984-05-01T00:00:00+00:00', '1995-08-16T00:00:00+00:00', true, false, false),
    (15506, 'INDIVIDUAL', NULL, 'Bad Hofgastein', 'Salzburg', 'SBG', 47.161944, 13.108056, 842, '2013-09-01T00:00:00+00:00', '2026-06-16T00:00:00+00:00', false, false, false),
    (15509, 'INDIVIDUAL', NULL, 'Großarltal', 'Salzburg', 'SBG', 47.24144, 13.19478, 882.3, '2011-02-14T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, false, true),
    (15515, 'INDIVIDUAL', 7, 'Bad Gastein/Böckstein', 'Salzburg', 'SBG', 47.092777, 13.120833, 1100, '1995-11-01T00:00:00+00:00', '2009-12-31T00:00:00+00:00', true, false, false),
    (15600, 'INDIVIDUAL', 68, 'Obertauern', 'Salzburg', 'SBG', 47.26667, 13.56667, 1742, '1984-09-01T00:00:00+00:00', '1994-03-31T00:00:00+00:00', true, true, false),
    (15610, 'INDIVIDUAL', 68, 'Obertauern', 'Salzburg', 'SBG', 47.24889, 13.55972, 1772, '1995-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15623, 'INDIVIDUAL', 68, 'Obertauern', 'Salzburg', 'SBG', 47.25, 13.55, 1775, '1971-06-01T00:00:00+00:00', '1973-09-30T00:00:00+00:00', true, false, false),
    (15624, 'INDIVIDUAL', 68, 'Obertauern', 'Salzburg', 'SBG', 47.25, 13.56667, 1755, '1980-03-01T00:00:00+00:00', '1981-12-31T00:00:00+00:00', true, false, false),
    (15640, 'INDIVIDUAL', NULL, 'Kölnbreinsperre', 'Kärnten', 'K', 47.08305, 13.346111, 1916, '2021-11-23T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15700, 'INDIVIDUAL', 92, 'St. Michael im Lungau', 'Salzburg', 'SBG', 47.1, 13.65, 1094, '1968-12-01T00:00:00+00:00', '1988-06-30T00:00:00+00:00', true, false, false),
    (15701, 'INDIVIDUAL', 92, 'St. Michael im Lungau', 'Salzburg', 'SBG', 47.095, 13.63167, 1049, '1988-07-01T00:00:00+00:00', '2008-10-31T00:00:00+00:00', true, false, false),
    (15702, 'INDIVIDUAL', 92, 'St. Michael im Lungau', 'Salzburg', 'SBG', 47.09447, 13.62269, 1051.9, '2008-06-25T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15706, 'INDIVIDUAL', 98, 'Tamsweg', 'Salzburg', 'SBG', 47.116665, 13.833333, 1024, '1895-10-01T00:00:00+00:00', '1939-01-31T00:00:00+00:00', false, false, false),
    (15707, 'INDIVIDUAL', 98, 'Tamsweg', 'Salzburg', 'SBG', 47.116665, 13.8, 1019, '1943-01-01T00:00:00+00:00', '1956-10-20T00:00:00+00:00', false, false, false),
    (15708, 'INDIVIDUAL', 98, 'Tamsweg', 'Salzburg', 'SBG', 47.133335, 13.833333, 1019, '1956-12-02T00:00:00+00:00', '1960-10-31T00:00:00+00:00', false, false, false),
    (15709, 'INDIVIDUAL', 98, 'Tamsweg', 'Salzburg', 'SBG', 47.116665, 13.8, 1012, '1960-12-01T00:00:00+00:00', '1983-02-28T00:00:00+00:00', false, false, false),
    (15710, 'INDIVIDUAL', 98, 'Tamsweg', 'Salzburg', 'SBG', 47.124722, 13.81, 1012, '1983-03-01T00:00:00+00:00', '1998-05-31T00:00:00+00:00', false, false, false),
    (15711, 'INDIVIDUAL', 98, 'Tamsweg', 'Salzburg', 'SBG', 47.124722, 13.81, 1025, '1998-06-01T00:00:00+00:00', '2008-09-30T00:00:00+00:00', false, false, false),
    (15712, 'INDIVIDUAL', 98, 'Tamsweg', 'Salzburg', 'SBG', 47.13306, 13.80833, 1025, '2008-06-25T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15715, 'INDIVIDUAL', NULL, 'Katschberg', 'Kärnten', 'K', 47.06056, 13.61472, 1635, '1998-10-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15721, 'INDIVIDUAL', NULL, 'Mariapfarr', 'Salzburg', 'SBG', 47.15222, 13.745, 1151, '1991-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15800, 'INDIVIDUAL', 186, 'Flattnitz', 'Kärnten', 'K', 46.944721, 14.035277, 1438, '1970-09-01T00:00:00+00:00', '2007-09-30T00:00:00+00:00', true, false, false),
    (15900, 'INDIVIDUAL', 182, 'Oberwölz', 'Steiermark', 'STMK', 47.201111, 14.283055, 810, '1936-01-01T00:00:00+00:00', '2001-04-30T00:00:00+00:00', true, false, false),
    (15901, 'INDIVIDUAL', 182, 'Oberwölz', 'Steiermark', 'STMK', 47.20206, 14.28669, 842.1, '2007-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15905, 'INDIVIDUAL', NULL, 'Krakauebene', 'Steiermark', 'STMK', 47.188057, 13.952778, 1312, '1990-10-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', true, false, false),
    (15906, 'INDIVIDUAL', NULL, 'Krakauebene Terrasse', 'Steiermark', 'STMK', 47.187222, 13.952222, 1310, '2000-07-01T00:00:00+00:00', '2001-12-01T00:00:00+00:00', false, true, false),
    (15910, 'INDIVIDUAL', 97, 'Stolzalpe', 'Steiermark', 'STMK', 47.116665, 14.2, 1305, '1938-01-01T00:00:00+00:00', '1999-10-31T00:00:00+00:00', true, false, false),
    (15911, 'INDIVIDUAL', 97, 'Stolzalpe', 'Steiermark', 'STMK', 47.121666, 14.185833, 1215, '2000-05-01T00:00:00+00:00', '2004-06-30T00:00:00+00:00', true, false, false),
    (15912, 'INDIVIDUAL', 97, 'Stolzalpe', 'Steiermark', 'STMK', 47.12303, 14.18822, 1291, '2007-07-24T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (15920, 'INDIVIDUAL', NULL, 'Murau', 'Steiermark', 'STMK', 47.11111, 14.17694, 816, '1989-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16000, 'INDIVIDUAL', 64, 'Neumarkt', 'Steiermark', 'STMK', 47.08333, 14.43333, 842, '1972-01-01T00:00:00+00:00', '1986-10-31T00:00:00+00:00', true, false, false),
    (16001, 'INDIVIDUAL', 64, 'Neumarkt', 'Steiermark', 'STMK', 47.083332, 14.416667, 881, '1936-01-01T00:00:00+00:00', '1971-12-31T00:00:00+00:00', false, false, false),
    (16003, 'INDIVIDUAL', NULL, 'Neumarkter Sattel', 'Steiermark', 'STMK', 47.070557, 14.425555, 1125, '1987-01-01T00:00:00+00:00', '1998-02-28T00:00:00+00:00', false, false, false),
    (16009, 'INDIVIDUAL', NULL, 'Zirbitzkogel', 'Steiermark', 'STMK', 47.066666, 14.566667, 2386, '1950-09-01T00:00:00+00:00', '1956-02-29T00:00:00+00:00', true, false, false),
    (16015, 'INDIVIDUAL', 64, 'Neumarkt', 'Steiermark', 'STMK', 47.06972, 14.42472, 869, '1993-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16100, 'INDIVIDUAL', 115, 'Zeltweg', 'Steiermark', 'STMK', 47.2, 14.78333, 669, '1962-10-01T00:00:00+00:00', '1992-05-31T00:00:00+00:00', true, false, false),
    (16101, 'INDIVIDUAL', 115, 'Zeltweg', 'Steiermark', 'STMK', 47.19983, 14.74689, 677.6, '1992-04-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16300, 'INDIVIDUAL', NULL, 'Lobming', 'Steiermark', 'STMK', 47.043056, 15.178333, 414, '1961-01-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', false, false, false),
    (16308, 'INDIVIDUAL', NULL, 'Köflach', 'Steiermark', 'STMK', 47.070277, 15.087222, 465, '2004-11-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16400, 'INDIVIDUAL', NULL, 'Graz Thalerhof Flughafen', 'Steiermark', 'STMK', 46.98056, 15.44, 340, '1936-02-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16401, 'INDIVIDUAL', NULL, 'Graz Messendorfberg', 'Steiermark', 'STMK', 47.046944, 15.489722, 435, '1972-12-01T00:00:00+00:00', '2001-08-16T00:00:00+00:00', true, false, false),
    (16402, 'INDIVIDUAL', 30, 'Graz Universität', 'Steiermark', 'STMK', 47.079723, 15.447778, 366, '1894-01-01T00:00:00+00:00', '1988-05-31T00:00:00+00:00', true, false, false),
    (16411, 'INDIVIDUAL', 94, 'St. Radegund', 'Steiermark', 'STMK', 47.18211, 15.48978, 726.3, '1986-04-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16412, 'INDIVIDUAL', 30, 'Graz Universität', 'Steiermark', 'STMK', 47.07767, 15.44892, 366.7, '1988-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16413, 'INDIVIDUAL', NULL, 'Graz Straßgang', 'Steiermark', 'STMK', 47.04611, 15.41028, 356.5, '2007-11-27T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16414, 'INDIVIDUAL', 30, 'Graz Universität/Heinrichstraße', 'Steiermark', 'STMK', 47.08, 15.448056, 366, '2022-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (16420, 'INDIVIDUAL', 86, 'Schöckl', 'Steiermark', 'STMK', 47.19861, 15.46806, 1436, '1928-01-01T00:00:00+00:00', '1992-12-31T00:00:00+00:00', true, false, false),
    (16421, 'INDIVIDUAL', 86, 'Schöckl', 'Steiermark', 'STMK', 47.19861, 15.46639, 1443, '1992-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16430, 'INDIVIDUAL', NULL, 'Graz Lendplatz', 'Steiermark', 'STMK', 47.07556, 15.4289, 351, '2022-11-17T00:00:00+00:00', '2100-12-31T00:00:00+00:00', false, false, true),
    (16431, 'INDIVIDUAL', NULL, 'Graz Lendplatz Feuerwehrturm', 'Steiermark', 'STMK', 47.07528, 15.4294, 351, '2022-11-17T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16440, 'INDIVIDUAL', NULL, 'Semriach', 'Steiermark', 'STMK', 47.216667, 15.4, 720, '1971-01-01T00:00:00+00:00', '1976-12-31T00:00:00+00:00', false, false, false),
    (16500, 'INDIVIDUAL', 200, 'Gleisdorf', 'Steiermark', 'STMK', 47.113335, 15.710834, 375, '1961-01-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', false, false, false),
    (16501, 'INDIVIDUAL', 200, 'Gleisdorf', 'Steiermark', 'STMK', 47.11556, 15.70806, 377.3, '2007-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16511, 'INDIVIDUAL', 53, 'Laßnitzhöhe', 'Steiermark', 'STMK', 47.07361, 15.59222, 530, '1990-02-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', true, true, true),
    (16520, 'INDIVIDUAL', 201, 'Weiz', 'Steiermark', 'STMK', 47.218613, 15.635555, 465, '1940-05-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', false, false, false),
    (16521, 'INDIVIDUAL', 201, 'Weiz', 'Steiermark', 'STMK', 47.218334, 15.634444, 465.7, '2007-06-01T00:00:00+00:00', '2014-04-08T00:00:00+00:00', true, true, false)
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
    RAISE NOTICE '006.4_klima_stations-5.sql: Last batch processed: % rows | Table public.klima_stations total: % (% COMBINED, % INDIVIDUAL)', 
        v_batch_count, v_total_count, v_combined_count, v_individual_count;
END $$;

COMMIT;