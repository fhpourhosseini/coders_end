SELECT k.objid, k.brand_date, mapping_id, m.gemeinde_id, m.station_id, rank, 
distance_km, st.is_active, st.valid_from, st.valid_to
	FROM public.gemeinde_station_mapping m
left join public.klima_stations st
on st.station_id = m.station_id
left join
(SELECT w.brand_date, w.gemeinde_id, w.objid  FROM public.wildfires w where  w.objid in (11659, 63068, 12167, 12937)) as k
ON k.gemeinde_id = m.gemeinde_id
where m.gemeinde_id in
	(SELECT gemeinde_id FROM public.wildfires where  objid in (11659, 63068, 12167, 12937))
order by m.gemeinde_id