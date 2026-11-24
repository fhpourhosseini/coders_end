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
    (16521, 'INDIVIDUAL', 201, 'Weiz', 'Steiermark', 'STMK', 47.218334, 15.634444, 465.7, '2007-06-01T00:00:00+00:00', '2014-04-08T00:00:00+00:00', true, true, false),
    (16522, 'INDIVIDUAL', NULL, 'Weiz', 'Steiermark', 'STMK', 47.2022, 15.635, 450, '2024-05-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', FALSE, FALSE, TRUE),
    (16600, 'INDIVIDUAL', 154, 'Fürstenfeld', 'Steiermark', 'STMK', 47.031113, 16.081667, 271, '1936-01-01T00:00:00+00:00', '2007-06-30T00:00:00+00:00', FALSE, FALSE, FALSE),
    (16601, 'INDIVIDUAL', 154, 'Fürstenfeld', 'Steiermark', 'STMK', 47.03083, 16.08083, 271, '2007-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE)
ON CONFLICT (station_id) DO UPDATE SET
type = EXCLUDED.type, group_id = EXCLUDED.group_id, name = EXCLUDED.name,
state = EXCLUDED.state, bundesland_code = EXCLUDED.bundesland_code,
lat = EXCLUDED.lat, lon = EXCLUDED.lon, altitude = EXCLUDED.altitude,
valid_from = EXCLUDED.valid_from, valid_to = EXCLUDED.valid_to,
has_sunshine = EXCLUDED.has_sunshine, has_global_radiation = EXCLUDED.has_global_radiation,
is_active = EXCLUDED.is_active;

INSERT INTO public.klima_stations (
    station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
    valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
    (16700, 'INDIVIDUAL', 183, 'Güssing', 'Burgenland', 'BGLD', 47.066666, 16.333334, 240, '1948-01-01T00:00:00+00:00', '1982-10-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (16701, 'INDIVIDUAL', NULL, 'Gerersdorf bei Güssing', 'Burgenland', 'BGLD', 47.071667, 16.237223, 280, '1983-07-01T00:00:00+00:00', '1995-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (16702, 'INDIVIDUAL', 183, 'Güssing', 'Burgenland', 'BGLD', 47.0625, 16.32186, 215.3, '2008-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (16710, 'INDIVIDUAL', 202, 'Wörterberg', 'Burgenland', 'BGLD', 47.22722, 16.09833, 400, '1929-07-02T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (16711, 'INDIVIDUAL', 202, 'Wörterberg', 'Burgenland', 'BGLD', 47.22619, 16.09678, 403.6, '2007-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(16800, 'INDIVIDUAL', 49, 'Kleinzicken', 'Burgenland', 'BGLD', 47.2075, 16.326667, 263, '1993-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(16802, 'INDIVIDUAL', 49, 'Kleinzicken', 'Burgenland', 'BGLD', 47.21667, 16.33333, 267, '1978-01-01T00:00:00+00:00', '1993-04-30T00:00:00+00:00', TRUE, FALSE, FALSE),
(16900, 'INDIVIDUAL', NULL, 'Obervermunt', 'Vorarlberg', 'VBG', 46.916668, 10.083333, 2040, '1963-10-01T00:00:00+00:00', '1996-08-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(16905, 'INDIVIDUAL', 220, 'Gaschurn', 'Vorarlberg', 'VBG', 46.98583, 10.02861, 976.3, '2007-08-01T00:00:00+00:00', '2021-10-06T00:00:00+00:00', TRUE, TRUE, FALSE),
(16906, 'INDIVIDUAL', 220, 'Gaschurn', 'Vorarlberg', 'VBG', 46.980278, 10.031667, 985, '2020-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(16910, 'INDIVIDUAL', NULL, 'Partenen', 'Vorarlberg', 'VBG', 46.966667, 10.05, 1028, '1963-10-01T00:00:00+00:00', '2021-04-01T00:00:00+00:00', FALSE, FALSE, FALSE),
(16920, 'INDIVIDUAL', NULL, 'Gargellen', 'Vorarlberg', 'VBG', 46.966667, 9.916667, 1474, '1935-01-01T00:00:00+00:00', '1962-09-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(17000, 'INDIVIDUAL', 28, 'Galtür', 'Tirol', 'T', 46.966667, 10.183333, 1583, '1901-01-01T00:00:00+00:00', '1989-03-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(17001, 'INDIVIDUAL', 28, 'Galtür', 'Tirol', 'T', 46.964443, 10.193611, 1648, '1989-04-01T00:00:00+00:00', '1996-11-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(17002, 'INDIVIDUAL', 28, 'Galtür', 'Tirol', 'T', 46.96806, 10.18556, 1587, '1996-11-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(17003, 'INDIVIDUAL', NULL, 'Galtür', 'Tirol', 'T', 46.964443, 10.189167, 1615, '2012-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', FALSE, FALSE, TRUE),
(17004, 'INDIVIDUAL', NULL, 'Galtür', 'Tirol', 'T', 46.972778, 10.185833, 1648, '2008-09-01T00:00:00+00:00', '2012-05-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(17005, 'INDIVIDUAL', NULL, 'Ischgl-Idalpe', 'Tirol', 'T', 46.9825, 10.31722, 2327, '1984-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(17006, 'INDIVIDUAL', NULL, 'Ischgl-Idalpe', 'Tirol', 'T', 46.981945, 10.317223, 2323, '2009-01-01T00:00:00+00:00', '2022-06-30T00:00:00+00:00', FALSE, FALSE, FALSE)
ON CONFLICT (station_id) DO UPDATE SET
type = EXCLUDED.type, group_id = EXCLUDED.group_id, name = EXCLUDED.name,
state = EXCLUDED.state, bundesland_code = EXCLUDED.bundesland_code,
lat = EXCLUDED.lat, lon = EXCLUDED.lon, altitude = EXCLUDED.altitude,
valid_from = EXCLUDED.valid_from, valid_to = EXCLUDED.valid_to,
has_sunshine = EXCLUDED.has_sunshine, has_global_radiation = EXCLUDED.has_global_radiation,
is_active = EXCLUDED.is_active;

--  STATIONS (ID 17100 to 21302)

INSERT INTO public.klima_stations (
    station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
    valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
    (17100, 'INDIVIDUAL', 121, 'Nauders', 'Tirol', 'T', 46.900002, 10.5, 1360, '1958-06-01T00:00:00+00:00', '2002-05-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (17101, 'INDIVIDUAL', 121, 'Nauders', 'Tirol', 'T', 46.900002, 10.5, 1360, '2002-06-01T00:00:00+00:00', '2004-07-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (17102, 'INDIVIDUAL', 121, 'Nauders', 'Tirol', 'T', 46.89111, 10.49694, 1330.2, '2004-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (17300, 'INDIVIDUAL', 66, 'Obergurgl', 'Tirol', 'T', 46.8675, 11.02722, 1938, '1953-01-01T00:00:00+00:00', '1998-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (17301, 'INDIVIDUAL', 66, 'Obergurgl', 'Tirol', 'T', 46.86694, 11.02444, 1941, '1999-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (17305, 'INDIVIDUAL', NULL, 'Vent', 'Tirol', 'T', 46.866665, 10.933333, 1908, '1940-01-01T00:00:00+00:00', '1977-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (17310, 'INDIVIDUAL', 184, 'Pitztaler Gletscher', 'Tirol', 'T', 46.933334, 10.883333, 2850, '1989-03-01T00:00:00+00:00', '1994-04-16T00:00:00+00:00', FALSE, FALSE, FALSE),
    (17315, 'INDIVIDUAL', 184, 'Pitztaler Gletscher', 'Tirol', 'T', 46.92706, 10.87914, 2863.9, '1994-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (17320, 'INDIVIDUAL', NULL, 'Brunnenkogel', 'Tirol', 'T', 46.91278, 10.86167, 3437, '2003-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (17700, 'INDIVIDUAL', 185, 'St. Jakob im Defereggental', 'Tirol', 'T', 46.917221, 12.354445, 1385, '1938-01-01T00:00:00+00:00', '2007-10-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (17701, 'INDIVIDUAL', 185, 'St. Jakob im Defereggental', 'Tirol', 'T', 46.91694, 12.35389, 1383, '2007-07-06T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (17900, 'INDIVIDUAL', 55, 'Lienz', 'Tirol', 'T', 46.81667, 12.78333, 663, '1880-01-01T00:00:00+00:00', '1985-11-30T00:00:00+00:00', TRUE, TRUE, FALSE),
    (17901, 'INDIVIDUAL', 55, 'Lienz', 'Tirol', 'T', 46.82555, 12.80639, 661, '1985-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18000, 'INDIVIDUAL', 137, 'Döllach-Sagritz', 'Kärnten', 'K', 46.958611, 12.903611, 1071, '1977-06-01T00:00:00+00:00', '2004-05-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18001, 'INDIVIDUAL', 137, 'Döllach', 'Kärnten', 'K', 46.95806, 12.9025, 1071, '2004-05-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18002, 'INDIVIDUAL', 137, 'Döllach im Mölltal', 'Kärnten', 'K', 46.966667, 12.9, 1024, '1926-08-01T00:00:00+00:00', '1976-08-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18010, 'INDIVIDUAL', NULL, 'Iselsberg', 'Kärnten', 'K', 46.855556, 12.858055, 1190, '1979-09-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18100, 'INDIVIDUAL', NULL, 'Kolbnitz', 'Kärnten', 'K', 46.873055, 13.312222, 603, '1953-05-01T00:00:00+00:00', '2001-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18111, 'INDIVIDUAL', 149, 'Mallnitz', 'Kärnten', 'K', 46.99194, 13.16667, 1197, '1987-03-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18120, 'INDIVIDUAL', 69, 'Obervellach', 'Kärnten', 'K', 46.933334, 13.233334, 778, '1970-09-01T00:00:00+00:00', '1981-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18121, 'INDIVIDUAL', 69, 'Obervellach', 'Kärnten', 'K', 46.92889, 13.22333, 809, '1986-12-01T00:00:00+00:00', '2015-02-01T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18122, 'INDIVIDUAL', 69, 'Obervellach', 'Kärnten', 'K', 46.93528, 13.19444, 688, '2014-07-09T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18200, 'INDIVIDUAL', NULL, 'Litzlhof', 'Kärnten', 'K', 46.833332, 13.433333, 580, '1961-01-01T00:00:00+00:00', '1992-10-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18210, 'INDIVIDUAL', 62, 'Millstatt', 'Kärnten', 'K', 46.80806, 13.57278, 721, '1982-06-24T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18211, 'INDIVIDUAL', 62, 'Millstatt/Kleindombra', 'Kärnten', 'K', 46.799999, 13.583333, 754, '1972-11-01T00:00:00+00:00', '1982-06-30T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18220, 'INDIVIDUAL', 150, 'Spittal an der Drau', 'Kärnten', 'K', 46.77472, 13.53611, 524, '1977-04-01T00:00:00+00:00', '2004-10-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18225, 'INDIVIDUAL', 150, 'Spittal an der Drau', 'Kärnten', 'K', 46.7905, 13.48725, 541.7, '1993-06-08T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18231, 'INDIVIDUAL', NULL, 'Gmünd', 'Kärnten', 'K', 46.90278, 13.53417, 738.4, '2008-07-23T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18240, 'INDIVIDUAL', 207, 'Reisseck', 'Kärnten', 'K', 46.933334, 13.366667, 2252, '1960-11-01T00:00:00+00:00', '1976-05-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18241, 'INDIVIDUAL', 207, 'Reisseckhütte', 'Kärnten', 'K', 46.916668, 13.366667, 2290, '1953-06-01T00:00:00+00:00', '1960-10-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18300, 'INDIVIDUAL', 128, 'Radenthein', 'Kärnten', 'K', 46.783333, 13.7, 685, '1958-11-01T00:00:00+00:00', '1998-07-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18305, 'INDIVIDUAL', 128, 'Radenthein', 'Kärnten', 'K', 46.798054, 13.698055, 685, '1998-08-01T00:00:00+00:00', '2000-11-30T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18306, 'INDIVIDUAL', 128, 'Radenthein', 'Kärnten', 'K', 46.800278, 13.698334, 688, '2000-12-01T00:00:00+00:00', '2002-08-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18402, 'INDIVIDUAL', 186, 'Flattnitz', 'Kärnten', 'K', 46.94083, 14.03611, 1437.2, '2007-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18500, 'INDIVIDUAL', 103, 'Weitensfeld', 'Kärnten', 'K', 46.84444, 14.19639, 705, '1985-09-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, TRUE, FALSE),
    (18501, 'INDIVIDUAL', 103, 'Weitensfeld', 'Kärnten', 'K', 46.85, 14.2, 715, '1953-01-01T00:00:00+00:00', '1985-08-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18502, 'INDIVIDUAL', 103, 'Weitensfeld', 'Kärnten', 'K', 46.84917, 14.19083, 704, '2007-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18600, 'INDIVIDUAL', 187, 'Friesach', 'Kärnten', 'K', 46.955276, 14.42, 634, '1958-05-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18601, 'INDIVIDUAL', 187, 'Friesach', 'Kärnten', 'K', 46.95861, 14.40583, 640, '2007-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18610, 'INDIVIDUAL', NULL, 'Silberegg', 'Kärnten', 'K', 46.849998, 14.5, 598, '1971-01-01T00:00:00+00:00', '1981-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18615, 'INDIVIDUAL', NULL, 'Althofen', 'Kärnten', 'K', 46.866665, 14.483334, 728, '1942-05-11T00:00:00+00:00', '1979-12-30T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18617, 'INDIVIDUAL', NULL, 'Treibach-Althofen', 'Kärnten', 'K', 46.863056, 14.460556, 612, '2024-01-10T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18620, 'INDIVIDUAL', 95, 'St. Veit an der Glan', 'Kärnten', 'K', 46.764721, 14.360556, 475, '1968-05-01T00:00:00+00:00', '1997-02-28T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18621, 'INDIVIDUAL', 95, 'St. Veit an der Glan', 'Kärnten', 'K', 46.759724, 14.345834, 475, '1997-03-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18622, 'INDIVIDUAL', 95, 'St. Veit an der Glan', 'Kärnten', 'K', 46.73917, 14.38556, 462.6, '2007-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18700, 'INDIVIDUAL', 90, 'St. Andrä-Winkling', 'Kärnten', 'K', 46.78333, 14.8, 468, '1976-09-01T00:00:00+00:00', '1992-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18704, 'INDIVIDUAL', 90, 'St. Andrä im Lavanttal', 'Kärnten', 'K', 46.766666, 14.816667, 430, '1961-01-01T00:00:00+00:00', '1975-06-30T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18705, 'INDIVIDUAL', 90, 'St. Andrä im Lavanttal', 'Kärnten', 'K', 46.76417, 14.82806, 403, '1993-03-11T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
    (18800, 'INDIVIDUAL', 71, 'Preitenegg', 'Kärnten', 'K', 46.93333, 14.91667, 1055, '1950-07-01T00:00:00+00:00', '1993-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18805, 'INDIVIDUAL', 71, 'Preitenegg', 'Kärnten', 'K', 46.938333, 14.920278, 1059, '1993-06-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE)
ON CONFLICT (station_id) DO UPDATE SET
type = EXCLUDED.type, group_id = EXCLUDED.group_id, name = EXCLUDED.name,
state = EXCLUDED.state, bundesland_code = EXCLUDED.bundesland_code,
lat = EXCLUDED.lat, lon = EXCLUDED.lon, altitude = EXCLUDED.altitude,
valid_from = EXCLUDED.valid_from, valid_to = EXCLUDED.valid_to,
has_sunshine = EXCLUDED.has_sunshine, has_global_radiation = EXCLUDED.has_global_radiation,
is_active = EXCLUDED.is_active;


INSERT INTO public.klima_stations (
    station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
    valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
    (18810, 'INDIVIDUAL', 110, 'Wolfsberg Reding', 'Kärnten', 'K', 46.833333, 14.85, 440, '1956-01-01T00:00:00+00:00', '1985-10-31T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18811, 'INDIVIDUAL', 110, 'Wolfsberg', 'Kärnten', 'K', 46.833332, 14.85, 442, '1985-11-01T00:00:00+00:00', '1987-10-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18813, 'INDIVIDUAL', 110, 'Wolfsberg Reding', 'Kärnten', 'K', 46.816666, 14.85, 435, '1953-01-01T00:00:00+00:00', '1955-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18900, 'INDIVIDUAL', 116, 'Deutschlandsberg', 'Steiermark', 'STMK', 46.816666, 15.216666, 380, '1895-08-01T00:00:00+00:00', '1996-01-31T00:00:00+00:00', FALSE, FALSE, FALSE),
    (18905, 'INDIVIDUAL', 116, 'Deutschlandsberg', 'Steiermark', 'STMK', 46.82167, 15.22889, 354, '1994-07-01T00:00:00+00:00', '2001-04-30T00:00:00+00:00', TRUE, FALSE, FALSE),
    (18906, 'INDIVIDUAL', 116, 'Deutschlandsberg', 'Steiermark', 'STMK', 46.82167, 15.22694, 354, '2001-05-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(19021, 'INDIVIDUAL', 54, 'Leibnitz-Wagna', 'Steiermark', 'STMK', 46.768056, 15.5525, 267, '2003-11-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(19200, 'INDIVIDUAL', 8, 'Bad Gleichenberg', 'Steiermark', 'STMK', 46.86666, 15.89999, 303, '1895-07-01T00:00:00+00:00', '1985-03-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(19201, 'INDIVIDUAL', 8, 'Bad Gleichenberg', 'Steiermark', 'STMK', 46.86666, 15.90194, 303, '1985-04-01T00:00:00+00:00', '2000-01-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(19204, 'INDIVIDUAL', 8, 'Bad Gleichenberg', 'Steiermark', 'STMK', 46.87222, 15.90361, 269, '2003-04-17T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(19205, 'INDIVIDUAL', NULL, 'Feldbach', 'Steiermark', 'STMK', 46.94889, 15.87972, 323, '1998-11-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(19500, 'INDIVIDUAL', 130, 'Sillian', 'Tirol', 'T', 46.75, 12.416667, 1100, '1964-12-01T00:00:00+00:00', '1999-09-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(19501, 'INDIVIDUAL', 130, 'Sillian', 'Tirol', 'T', 46.75, 12.416667, 1080, '1948-01-01T00:00:00+00:00', '1964-04-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(19505, 'INDIVIDUAL', 130, 'Sillian', 'Tirol', 'T', 46.74644, 12.42358, 1081.4, '1996-09-19T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(19700, 'INDIVIDUAL', 19, 'Dellach', 'Kärnten', 'K', 46.74189, 13.08286, 628.2, '1983-05-05T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, FALSE, TRUE),
(19701, 'INDIVIDUAL', 19, 'Dellach', 'Kärnten', 'K', 46.733334, 13.083333, 620, '1962-05-01T00:00:00+00:00', '1983-04-30T00:00:00+00:00', TRUE, FALSE, FALSE),
(19710, 'INDIVIDUAL', NULL, 'Kornat', 'Kärnten', 'K', 46.688057, 12.889444, 1047, '1948-01-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(19711, 'INDIVIDUAL', NULL, 'Kornat', 'Kärnten', 'K', 46.685001, 12.888889, 990, '2017-05-22T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(19715, 'INDIVIDUAL', NULL, 'Vorhegg', 'Kärnten', 'K', 46.677776, 12.972222, 1020, '1990-12-01T00:00:00+00:00', '2010-04-30T00:00:00+00:00', TRUE, TRUE, FALSE),
(19720, 'INDIVIDUAL', NULL, 'Kötschach-Mauthen', 'Kärnten', 'K', 46.67638, 12.99833, 705, '1987-03-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(19730, 'INDIVIDUAL', 208, 'Laas', 'Kärnten', 'K', 46.683334, 12.983334, 800, '1969-07-01T00:00:00+00:00', '1978-05-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(19731, 'INDIVIDUAL', 208, 'Laas', 'Kärnten', 'K', 46.683334, 12.983334, 891, '1944-05-01T00:00:00+00:00', '1968-09-30T00:00:00+00:00', TRUE, FALSE, FALSE),
(19800, 'INDIVIDUAL', NULL, 'Reisach', 'Kärnten', 'K', 46.648335, 13.154166, 646, '1961-01-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(19810, 'INDIVIDUAL', NULL, 'Weißbriach', 'Kärnten', 'K', 46.683334, 13.25, 817, '1966-09-08T00:00:00+00:00', '1981-01-01T00:00:00+00:00', TRUE, FALSE, FALSE),
(19821, 'INDIVIDUAL', 102, 'Weißensee-Gatschach', 'Kärnten', 'K', 46.71861, 13.28583, 949, '1982-10-14T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(19830, 'INDIVIDUAL', NULL, 'Nassfeld', 'Kärnten', 'K', 46.566666, 13.283334, 1525, '1970-01-01T00:00:00+00:00', '1978-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(19911, 'INDIVIDUAL', NULL, 'Hermagor', 'Kärnten', 'K', 46.60972, 13.49222, 561.6, '2008-07-23T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20000, 'INDIVIDUAL', 6, 'Bad Bleiberg', 'Kärnten', 'K', 46.616665, 13.683333, 904, '1896-01-01T00:00:00+00:00', '1985-04-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20001, 'INDIVIDUAL', 6, 'Bad Bleiburg', 'Kärnten', 'K', 46.625, 13.688889, 907, '1985-05-01T00:00:00+00:00', '2007-09-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20002, 'INDIVIDUAL', 6, 'Bad Bleiberg', 'Kärnten', 'K', 46.62528, 13.68444, 908.7, '2007-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20005, 'INDIVIDUAL', NULL, 'Kreuth', 'Kärnten', 'K', 46.616665, 13.666667, 835, '1981-05-01T00:00:00+00:00', '1985-04-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20010, 'INDIVIDUAL', 203, 'Fresach', 'Kärnten', 'K', 46.71444, 13.695, 748, '1973-10-01T00:00:00+00:00', '2008-09-30T00:00:00+00:00', TRUE, FALSE, FALSE),
(20011, 'INDIVIDUAL', 203, 'Fresach', 'Kärnten', 'K', 46.71528, 13.68528, 683, '2008-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20020, 'INDIVIDUAL', NULL, 'Villacher Alpe', 'Kärnten', 'K', 46.60361, 13.67333, 2140, '1921-11-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, FALSE, TRUE),
(20021, 'INDIVIDUAL', NULL, 'Villacher Alpe', 'Kärnten', 'K', 46.60361, 13.67278, 2117, '1994-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20041, 'INDIVIDUAL', NULL, 'Petzen', 'Kärnten', 'K', 46.517278, 14.771028, 1704, '2026-10-29T00:00:00+00:00', '2100-12-31T00:00:00+00:00', FALSE, FALSE, TRUE),
(20100, 'INDIVIDUAL', 122, 'Kanzelhöhe', 'Kärnten', 'K', 46.678055, 13.906667, 1526, '1953-04-01T00:00:00+00:00', '2001-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(20101, 'INDIVIDUAL', 122, 'Kanzelhöhe', 'Kärnten', 'K', 46.67722, 13.90194, 1520, '2002-01-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20102, 'INDIVIDUAL', 122, 'Kanzelhöhe', 'Kärnten', 'K', 46.666668, 13.9, 1477, '1938-01-01T00:00:00+00:00', '1952-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(20105, 'INDIVIDUAL', NULL, 'Arriach', 'Kärnten', 'K', 46.72769, 13.85244, 890.2, '1990-06-21T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20106, 'INDIVIDUAL', NULL, 'Arriach', 'Kärnten', 'K', 46.733334, 13.85, 896, '1947-08-07T00:00:00+00:00', '1952-06-30T00:00:00+00:00', TRUE, FALSE, FALSE),
(20110, 'INDIVIDUAL', NULL, 'Velden', 'Kärnten', 'K', 46.616665, 14.033334, 535, '1961-01-01T00:00:00+00:00', '1982-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(20116, 'INDIVIDUAL', 100, 'Villach Vassach', 'Kärnten', 'K', 46.633335, 13.85, 533, '1930-01-01T00:00:00+00:00', '1947-08-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20117, 'INDIVIDUAL', 100, 'Villach Perau', 'Kärnten', 'K', 46.599998, 13.85, 493, '1951-07-01T00:00:00+00:00', '1954-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20118, 'INDIVIDUAL', 100, 'Villach Seebach', 'Kärnten', 'K', 46.61694, 13.8775, 492, '1969-04-01T00:00:00+00:00', '1981-12-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(20119, 'INDIVIDUAL', 100, 'Villach Maria Gail', 'Kärnten', 'K', 46.599998, 13.883333, 504, '1955-05-01T00:00:00+00:00', '1968-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20121, 'INDIVIDUAL', 100, 'Villach Seebach', 'Kärnten', 'K', 46.633335, 13.85, 495, '1948-02-01T00:00:00+00:00', '1951-06-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20122, 'INDIVIDUAL', 100, 'Villach', 'Kärnten', 'K', 46.61667, 13.86667, 495, '1982-06-01T00:00:00+00:00', '1993-11-30T00:00:00+00:00', TRUE, FALSE, FALSE),
(20123, 'INDIVIDUAL', 100, 'Villach Stadt', 'Kärnten', 'K', 46.61806, 13.87389, 493, '1993-12-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20200, 'INDIVIDUAL', 120, 'Ferlach', 'Kärnten', 'K', 46.532501, 14.303333, 474, '1953-05-01T00:00:00+00:00', '2002-03-31T00:00:00+00:00', TRUE, FALSE, FALSE)
ON CONFLICT (station_id) DO UPDATE SET
type = EXCLUDED.type, group_id = EXCLUDED.group_id, name = EXCLUDED.name,
state = EXCLUDED.state, bundesland_code = EXCLUDED.bundesland_code,
lat = EXCLUDED.lat, lon = EXCLUDED.lon, altitude = EXCLUDED.altitude,
valid_from = EXCLUDED.valid_from, valid_to = EXCLUDED.valid_to,
has_sunshine = EXCLUDED.has_sunshine, has_global_radiation = EXCLUDED.has_global_radiation,
is_active = EXCLUDED.is_active;

INSERT INTO public.klima_stations (
station_id, type, group_id, name, state, bundesland_code, lat, lon, altitude,
valid_from, valid_to, has_sunshine, has_global_radiation, is_active
)
VALUES
(20201, 'INDIVIDUAL', 120, 'Ferlach', 'Kärnten', 'K', 46.530277, 14.295278, 460, '2002-05-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20202, 'INDIVIDUAL', 120, 'Ferlach', 'Kärnten', 'K', 46.53111, 14.31417, 459.1, '2007-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20203, 'INDIVIDUAL', NULL, 'Klagenfurt Stadtpfarramt', 'Kärnten', 'K', 46.625832, 14.307222, 446, '1923-09-01T00:00:00+00:00', '1940-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20204, 'INDIVIDUAL', NULL, 'Klagenfurt Fliegerhorst', 'Kärnten', 'K', 46.645832, 14.326944, 448, '1939-03-01T00:00:00+00:00', '1945-01-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(20205, 'INDIVIDUAL', NULL, 'Klagenfurt St. Martin', 'Kärnten', 'K', 46.633335, 14.283334, 454, '1944-06-01T00:00:00+00:00', '1950-04-19T00:00:00+00:00', TRUE, FALSE, FALSE),
(20206, 'INDIVIDUAL', NULL, 'Klagenfurt Strandbad', 'Kärnten', 'K', 46.6175, 14.2544, 441, '2026-04-14T00:00:00+00:00', '2100-12-31T00:00:00+00:00', FALSE, FALSE, TRUE),
(20209, 'INDIVIDUAL', NULL, 'Klagenfurt/HTL1-Lastenstraße', 'Kärnten', 'K', 46.61944, 14.316667, 441, '2021-04-21T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20210, 'INDIVIDUAL', 48, 'Klagenfurt Flughafen', 'Kärnten', 'K', 46.65001, 14.33333, 447, '1885-09-02T00:00:00+00:00', '1991-03-31T00:00:00+00:00', TRUE, TRUE, FALSE),
(20211, 'INDIVIDUAL', 48, 'Klagenfurt Flughafen', 'Kärnten', 'K', 46.65001, 14.33333, 447, '1991-04-01T00:00:00+00:00', '1996-08-31T00:00:00+00:00', TRUE, TRUE, FALSE),
(20212, 'INDIVIDUAL', 48, 'Klagenfurt Flughafen', 'Kärnten', 'K', 46.64833, 14.31833, 450, '1996-09-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20213, 'INDIVIDUAL', NULL, 'Klagenfurt', 'Kärnten', 'K', 46.650002, 14.333333, 447, '1996-11-01T00:00:00+00:00', '2008-03-31T00:00:00+00:00', TRUE, FALSE, FALSE),
(20214, 'INDIVIDUAL', 48, 'Klagenfurt Landesmuseum', 'Kärnten', 'K', 46.620833, 14.312222, 449, '1830-01-01T00:00:00+00:00', '1952-07-15T00:00:00+00:00', TRUE, FALSE, FALSE),
(20219, 'INDIVIDUAL', 198, 'Pörtschach', 'Kärnten', 'K', 46.633335, 14.166667, 441, '1978-05-01T00:00:00+00:00', '1982-09-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20220, 'INDIVIDUAL', 198, 'Pörtschach', 'Kärnten', 'K', 46.63083, 14.16528, 450, '1982-10-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20230, 'INDIVIDUAL', NULL, 'Rupertiberg', 'Kärnten', 'K', 46.566666, 14.1, 715, '1964-04-01T00:00:00+00:00', '1993-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20240, 'INDIVIDUAL', NULL, 'Feistritz im Rosental', 'Kärnten', 'K', 46.52833, 14.14555, 466, '1962-12-01T00:00:00+00:00', '1980-06-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20270, 'INDIVIDUAL', NULL, 'Feldkirchen', 'Kärnten', 'K', 46.72194, 14.09694, 546.4, '1995-07-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20300, 'INDIVIDUAL', NULL, 'Höhenbergen bei Tainach', 'Kärnten', 'K', 46.638054, 14.55, 437, '1978-05-01T00:00:00+00:00', '2006-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20305, 'INDIVIDUAL', NULL, 'Hörzendorf/St.Veit', 'Kärnten', 'K', 46.732224, 14.346389, 492, '1961-01-01T00:00:00+00:00', '1968-04-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20330, 'INDIVIDUAL', NULL, 'Hochobir', 'Kärnten', 'K', 46.5, 14.483334, 2041, '1880-08-01T00:00:00+00:00', '1944-06-30T00:00:00+00:00', TRUE, FALSE, FALSE),
(20400, 'INDIVIDUAL', 91, 'St. Michael ob Bleiburg', 'Kärnten', 'K', 46.583332, 14.75, 500, '1961-01-01T00:00:00+00:00', '1991-03-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20401, 'INDIVIDUAL', 91, 'Feistritz ob Bleiburg', 'Kärnten', 'K', 46.55833, 14.76583, 527, '1991-10-01T00:00:00+00:00', '1999-08-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20402, 'INDIVIDUAL', 91, 'St. Michael ob Bleiburg', 'Kärnten', 'K', 46.579166, 14.765833, 490, '1999-09-01T00:00:00+00:00', '2000-09-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20403, 'INDIVIDUAL', 91, 'St. Michael ob Bleiburg', 'Kärnten', 'K', 46.578335, 14.749444, 500, '2000-10-01T00:00:00+00:00', '2002-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20404, 'INDIVIDUAL', 91, 'Feistritz ob Bleiburg', 'Kärnten', 'K', 46.55917, 14.7675, 530, '2003-08-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20405, 'INDIVIDUAL', 188, 'Völkermarkt', 'Kärnten', 'K', 46.666668, 14.633333, 465, '1950-12-01T00:00:00+00:00', '1977-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20406, 'INDIVIDUAL', 188, 'Völkermarkt Goldbrunnhof', 'Kärnten', 'K', 46.666668, 14.633333, 465, '1978-01-01T00:00:00+00:00', '1978-03-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20408, 'INDIVIDUAL', 188, 'Völkermarkt', 'Kärnten', 'K', 46.661388, 14.618611, 473.1, '2008-07-23T00:00:00+00:00', '2015-10-13T00:00:00+00:00', TRUE, TRUE, FALSE),
(20411, 'INDIVIDUAL', 188, 'Völkermarkt Goldbrunnhof', 'Kärnten', 'K', 46.670834, 14.639167, 466, '2015-10-20T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20412, 'INDIVIDUAL', 91, 'Feistritz ob Bleiburg', 'Kärnten', 'K', 46.561389, 14.765, 523, '2007-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(20500, 'INDIVIDUAL', 209, 'St. Paul im Lavanttal', 'Kärnten', 'K', 46.700001, 14.866667, 384, '1962-01-01T00:00:00+00:00', '1981-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20501, 'INDIVIDUAL', 209, 'St. Paul im Lavanttal', 'Kärnten', 'K', 46.700001, 14.866667, 409, '1936-01-01T00:00:00+00:00', '1961-09-30T00:00:00+00:00', FALSE, FALSE, FALSE),
(20600, 'INDIVIDUAL', NULL, 'Wiel', 'Steiermark', 'STMK', 46.746113, 15.129444, 928, '1965-04-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20900, 'INDIVIDUAL', 11, 'Bad Radkersburg', 'Steiermark', 'STMK', 46.700001, 15.983334, 208, '1972-04-01T00:00:00+00:00', '1992-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(20901, 'INDIVIDUAL', 11, 'Bad Radkersburg', 'Steiermark', 'STMK', 46.68667, 15.97861, 208, '1992-11-01T00:00:00+00:00', '2000-12-31T00:00:00+00:00', TRUE, TRUE, FALSE),
(20902, 'INDIVIDUAL', 11, 'Bad Radkersburg', 'Steiermark', 'STMK', 46.68583, 15.97944, 209.8, '2001-02-01T00:00:00+00:00', '2016-04-06T00:00:00+00:00', TRUE, TRUE, FALSE),
(20903, 'INDIVIDUAL', 11, 'Bad Radkersburg', 'Steiermark', 'STMK', 46.69222, 15.99333, 207, '2016-04-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(21100, 'INDIVIDUAL', 206, 'Loibl Tunnel', 'Kärnten', 'K', 46.444443, 14.25, 1098, '1959-01-01T00:00:00+00:00', '2007-12-31T00:00:00+00:00', FALSE, FALSE, FALSE),
(21101, 'INDIVIDUAL', 206, 'Loibl Tunnel', 'Kärnten', 'K', 46.44389, 14.24917, 1096.9, '2007-08-01T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(21300, 'INDIVIDUAL', 21, 'Bad Eisenkappel', 'Kärnten', 'K', 46.49056, 14.59333, 623, '1982-11-18T00:00:00+00:00', '2100-12-31T00:00:00+00:00', TRUE, TRUE, TRUE),
(21302, 'INDIVIDUAL', 21, 'Eisenkappel', 'Kärnten', 'K', 46.483334, 14.6, 605, '1967-03-01T00:00:00+00:00', '1982-12-31T00:00:00+00:00', TRUE, FALSE, FALSE)
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