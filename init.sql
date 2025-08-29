--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: login; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login (
    emailid character varying(255) NOT NULL,
    name character varying(100) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.login OWNER TO postgres;

--
-- Name: passengerbooking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passengerbooking (
    email character varying(255) NOT NULL,
    name character varying(100) NOT NULL,
    starting character varying(100) NOT NULL,
    destination character varying(100) NOT NULL
);


ALTER TABLE public.passengerbooking OWNER TO postgres;

--
-- Name: supplementpassengers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplementpassengers (
    email character varying(255) NOT NULL,
    intermediate_station character varying(100) NOT NULL,
    passenger_email character varying(255)
);


ALTER TABLE public.supplementpassengers OWNER TO postgres;

--
-- Name: train; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train (
    station character varying(100) NOT NULL,
    value integer NOT NULL
);


ALTER TABLE public.train OWNER TO postgres;

--
-- Data for Name: login; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login (emailid, name, password) FROM stdin;
chinthakuntlaharish01@gmail.com	Harish	harish
\.


--
-- Data for Name: passengerbooking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passengerbooking (email, name, starting, destination) FROM stdin;
chinthakuntlaharish01@gmail.com	Chinthakuntla Harish Reddy	Station B	Station E
\.


--
-- Data for Name: supplementpassengers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplementpassengers (email, intermediate_station, passenger_email) FROM stdin;
\.


--
-- Data for Name: train; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train (station, value) FROM stdin;
Station A	1
Station B	2
Station C	3
Station D	4
Station E	5
\.


--
-- Name: login login_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login
    ADD CONSTRAINT login_pkey PRIMARY KEY (emailid);


--
-- Name: passengerbooking passengerbooking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passengerbooking
    ADD CONSTRAINT passengerbooking_pkey PRIMARY KEY (email);


--
-- Name: supplementpassengers supplementpassengers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplementpassengers
    ADD CONSTRAINT supplementpassengers_pkey PRIMARY KEY (email);


--
-- Name: train train_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train
    ADD CONSTRAINT train_pkey PRIMARY KEY (station);


--
-- Name: supplementpassengers supplementpassengers_passenger_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplementpassengers
    ADD CONSTRAINT supplementpassengers_passenger_email_fkey FOREIGN KEY (passenger_email) REFERENCES public.passengerbooking(email);


--
-- PostgreSQL database dump complete
--

