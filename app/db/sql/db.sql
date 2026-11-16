-- Database: coders_end_db

-- DROP DATABASE IF EXISTS coders_end_db;

CREATE DATABASE coders_end_db
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- SCHEMA: retail

-- DROP SCHEMA IF EXISTS retail ;

CREATE SCHEMA IF NOT EXISTS retail
    AUTHORIZATION postgres;

-- Table: retail.user

-- DROP TABLE IF EXISTS retail."user";

CREATE TABLE IF NOT EXISTS retail."user"
(
    uid uuid NOT NULL,
    login character varying(40)[] COLLATE pg_catalog."default" NOT NULL,
    pwd character varying(40)[] COLLATE pg_catalog."default" NOT NULL,
    datetime timestamp with time zone NOT NULL,
    CONSTRAINT id PRIMARY KEY (uid),
    CONSTRAINT login UNIQUE (login)
        INCLUDE(login)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS retail."user"
    OWNER to postgres;

-- Table: retail.user_action

-- DROP TABLE IF EXISTS retail.user_action;

CREATE TABLE IF NOT EXISTS retail.user_action
(
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    action character varying(100) COLLATE pg_catalog."default" NOT NULL,
    datetime timestamp with time zone NOT NULL,
    details character varying(200)[] COLLATE pg_catalog."default" NOT NULL,
    link character varying(200)[] COLLATE pg_catalog."default",
    CONSTRAINT user_action_pkey PRIMARY KEY (id),
    CONSTRAINT unq_key UNIQUE (user_id, action, datetime),
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES retail."user" (uid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS retail.user_action
    OWNER to postgres;