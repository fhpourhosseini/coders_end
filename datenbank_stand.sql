--
-- PostgreSQL database dump
--

\restrict dlfLSpEyjbGanfNPt7Uqaf59BbHaOPehpjB0kGhbaXqaOiSThlTXPeIwiHri1pw

-- Dumped from database version 17.11 (Debian 17.11-1.pgdg13+2)
-- Dumped by pg_dump version 17.11 (Debian 17.11-1.pgdg13+2)
SET client_encoding = 'WIN1252';
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: pipeline_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pipeline_jobs (
    job_id character varying(50) NOT NULL,
    status character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.pipeline_jobs OWNER TO postgres;

--
-- Name: query_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query_history (
    id integer NOT NULL,
    username text,
    sql_query text NOT NULL,
    query_result text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.query_history OWNER TO postgres;

--
-- Name: query_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.query_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.query_history_id_seq OWNER TO postgres;

--
-- Name: query_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.query_history_id_seq OWNED BY public.query_history.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    username text NOT NULL,
    password_hash text NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: waldbrand_ergebnisse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.waldbrand_ergebnisse (
    id integer NOT NULL,
    username character varying(50),
    bundesland character varying(50),
    gemeinde character varying(100),
    latitude double precision,
    longitude double precision,
    wahrscheinlichkeit_prozent integer,
    abfrage_zeit timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.waldbrand_ergebnisse OWNER TO postgres;

--
-- Name: waldbrand_ergebnisse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.waldbrand_ergebnisse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.waldbrand_ergebnisse_id_seq OWNER TO postgres;

--
-- Name: waldbrand_ergebnisse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.waldbrand_ergebnisse_id_seq OWNED BY public.waldbrand_ergebnisse.id;


--
-- Name: query_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_history ALTER COLUMN id SET DEFAULT nextval('public.query_history_id_seq'::regclass);


--
-- Name: waldbrand_ergebnisse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waldbrand_ergebnisse ALTER COLUMN id SET DEFAULT nextval('public.waldbrand_ergebnisse_id_seq'::regclass);


--
-- Data for Name: pipeline_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pipeline_jobs (job_id, status, created_at) FROM stdin;
cbfff95f-f4f4-4b62-b48f-98796b24a8ff	completed	2026-11-15 00:40:20.111026
\.


--
-- Data for Name: query_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query_history (id, username, sql_query, query_result, created_at) FROM stdin;
1	test	Wetter- & Waldbrandrisiko-Analyse für Wien	{"Abfrage-Datum": "10.11.2026 18:28:26", "Bundesland": "Wien", "Zeitraum": "Letzte 14 Tage", "Stationen_ausgelesen": 4, "Status": "Erfolgreich"}	2026-11-10 18:28:26.776604
2	test	Wetter- & Waldbrandrisiko-Analyse für Niederösterreich	{"Abfrage-Datum": "10.11.2026 18:28:35", "Bundesland": "Nieder\\u00f6sterreich", "Zeitraum": "Letzte 14 Tage", "Stationen_ausgelesen": 4, "Status": "Erfolgreich"}	2026-11-10 18:28:35.612867
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (username, password_hash) FROM stdin;
test	9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08
\.


--
-- Data for Name: waldbrand_ergebnisse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waldbrand_ergebnisse (id, username, bundesland, gemeinde, latitude, longitude, wahrscheinlichkeit_prozent, abfrage_zeit) FROM stdin;
11	test	Wien	Wien-Donaustadt	48.2206	16.4694	78	2026-11-10 20:36:19.482728
12	test	Wien	Wien-Hietzing	48.1833	16.2833	25	2026-11-10 20:36:19.482728
13	test	Steiermark	Graz-Umgebung	47.0707	15.4395	62	2026-11-10 20:36:19.482728
1	test	Wien	Wien	48.208174	16.373819	89	2026-11-10 21:25:00
2	test	Niederösterreich	St. Pölten	48.204722	15.625556	64	2026-11-10 21:25:05
3	test	Oberösterreich	Linz	48.30694	14.28583	79	2026-11-10 21:25:10
4	test	Steiermark	Graz	47.070714	15.439504	92	2026-11-10 21:25:15
5	test	Tirol	Innsbruck	47.269212	11.404102	45	2026-11-10 21:25:20
6	test	Kärnten	Klagenfurt am Wörthersee	46.63646	14.312225	54	2026-11-10 21:25:25
7	test	Salzburg	Salzburg	47.80949	13.05501	72	2026-11-10 21:25:30
8	test	Vorarlberg	Bregenz	47.50311	9.7471	39	2026-11-10 21:25:35
9	test	Burgenland	Eisenstadt	47.84565	16.51892	61	2026-11-10 21:25:40
10	test	Niederösterreich	Wiener Neustadt	47.813056	16.246389	82	2026-11-10 21:25:45
14	test	Wien	Beispielgemeinde Nord	48.2082	16.3738	78	2026-11-15 00:40:23.125426
15	test	Wien	Beispielgemeinde Süd	48.15	16.3	24	2026-11-15 00:40:23.125426
\.


--
-- Name: query_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.query_history_id_seq', 2, true);


--
-- Name: waldbrand_ergebnisse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.waldbrand_ergebnisse_id_seq', 15, true);


--
-- Name: pipeline_jobs pipeline_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pipeline_jobs
    ADD CONSTRAINT pipeline_jobs_pkey PRIMARY KEY (job_id);


--
-- Name: query_history query_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_history
    ADD CONSTRAINT query_history_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- Name: waldbrand_ergebnisse waldbrand_ergebnisse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waldbrand_ergebnisse
    ADD CONSTRAINT waldbrand_ergebnisse_pkey PRIMARY KEY (id);


--
-- Name: query_history query_history_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_history
    ADD CONSTRAINT query_history_username_fkey FOREIGN KEY (username) REFERENCES public.users(username) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict dlfLSpEyjbGanfNPt7Uqaf59BbHaOPehpjB0kGhbaXqaOiSThlTXPeIwiHri1pw

