-- Create Staging Schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS public;

-- LOOKUP TABLES

-- State Lookup (e.g., 'K', 'T', 'NOE')
CREATE TABLE IF NOT EXISTS public.bundesland (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NULL
);

-- Municipality Lookup (linked to states, names prioritized from gemeinde_neu)
CREATE TABLE IF NOT EXISTS public.gemeinde (
    gemeinde_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bundesland_code VARCHAR(10) REFERENCES public.bundesland(code),
    CONSTRAINT unique_gemeinde_per_state UNIQUE (name, bundesland_code)
);

-- Fire Type Classification Lookup
CREATE TABLE IF NOT EXISTS public.brandart (
    brandart_id INT PRIMARY KEY,
    name VARCHAR(100) NULL
);

-- Cause Classification Lookup
CREATE TABLE IF NOT EXISTS public.ursache (
    ursache_id INT PRIMARY KEY,
    name VARCHAR(100) NULL
);

-- CORE TABLE (wildfires)

CREATE TABLE IF NOT EXISTS public.wildfires (
    objid INT PRIMARY KEY,
    waldbrandid BIGINT NULL,
    brand_date DATE NULL, -- Combined 
    jahr INT NULL,
    monat INT NULL,
    tag INT NULL,
    gemeinde_id INT REFERENCES public.gemeinde(gemeinde_id),
    brandart_id INT REFERENCES public.brandart(brandart_id),
    ursache_id INT REFERENCES public.ursache(ursache_id),
    brandflaeche NUMERIC NULL,
    brandflaeche_korr NUMERIC NULL,
    feuerwehren INT NULL,       
    einsatzkraefte INT NULL,    
    quelle1 TEXT NULL,
    verifiziert BOOLEAN NULL,
    schutzwald SMALLINT NULL,   
    longitude DOUBLE PRECISION NULL, 
    latitude DOUBLE PRECISION NULL   
);

