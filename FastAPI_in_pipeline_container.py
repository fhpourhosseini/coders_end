import os
import time
import uuid
from typing import Optional
from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException, BackgroundTasks
from pydantic import BaseModel
import psycopg2
from psycopg2.extras import RealDictCursor
import bcrypt


# --- Passwort-Helfer ---
def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return bcrypt.checkpw(plain_password.encode("utf-8"), hashed_password.encode("utf-8"))


# --- Datenbank-Verbindung ---
def get_db_connection():
    return psycopg2.connect(
        host="db-container",
        port="5432",
        database=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_DATABASE"],
        user=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_USERNAME"],
        password=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_PASSWORD"]
    )


# --- Tabellen beim Start der API anlegen ---
@asynccontextmanager
async def lifespan(app: FastAPI):
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id SERIAL PRIMARY KEY,
                    username VARCHAR(50) UNIQUE NOT NULL,
                    password_hash TEXT NOT NULL
                );
            """)
            cur.execute("""
                CREATE TABLE IF NOT EXISTS waldbrand_ergebnisse (
                    id SERIAL PRIMARY KEY,
                    username VARCHAR(50),
                    bundesland VARCHAR(50),
                    gemeinde VARCHAR(100),
                    latitude DOUBLE PRECISION,
                    longitude DOUBLE PRECISION,
                    wahrscheinlichkeit_prozent INT,
                    abfrage_zeit TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """)
            conn.commit()
    finally:
        conn.close()
    yield


app = FastAPI(lifespan=lifespan)

# Speicher für laufende Dummy-Pipeline-Jobs
jobs = {}


# --- Datenmodelle ---
class UserAuth(BaseModel):
    username: str
    password: str

class ErgebnisCreate(BaseModel):
    username: str
    bundesland: str
    gemeinde: str
    latitude: float
    longitude: float
    wahrscheinlichkeit_prozent: int

class PipelineStartRequest(BaseModel):
    username: str
    bundesland: str


# --- Auth-Endpunkte ---
@app.post("/register")
def register(user: UserAuth):
    conn = get_db_connection()
    hashed_pw = hash_password(user.password)
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT id FROM users WHERE username = %s", (user.username,))
            if cur.fetchone():
                raise HTTPException(status_code=400, detail="Nutzername existiert bereits")
            cur.execute(
                "INSERT INTO users (username, password_hash) VALUES (%s, %s)",
                (user.username, hashed_pw)
            )
            conn.commit()
        return {"message": "Erfolgreich registriert"}
    finally:
        conn.close()

@app.post("/login")
def login(user: UserAuth):
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT password_hash FROM users WHERE username = %s", (user.username,))
            result = cur.fetchone()
            if not result or not verify_password(user.password, result[0]):
                raise HTTPException(status_code=401, detail="Falscher Nutzername oder Kennwort")
        return {"message": "Login erfolgreich", "username": user.username}
    finally:
        conn.close()


# --- Dummy-Pipeline-Endpunkte ---
def dummy_pipeline_task(job_id: str, username: str, bundesland: str):
    """Simuliert die Rechenzeit deiner KI-Pipeline."""
    time.sleep(2)
    jobs[job_id] = "completed"

@app.post("/start")
def start_pipeline(req: PipelineStartRequest, background_tasks: BackgroundTasks):
    job_id = str(uuid.uuid4())
    jobs[job_id] = "running"
    background_tasks.add_task(dummy_pipeline_task, job_id, req.username, req.bundesland)
    return {"job_id": job_id, "status": "running"}

@app.get("/status/{job_id}")
def get_pipeline_status(job_id: str):
    status = jobs.get(job_id)
    if not status:
        raise HTTPException(status_code=404, detail="Job nicht gefunden")
    return {"job_id": job_id, "status": status}


# --- Ergebnis-Endpunkte ---
@app.post("/ergebnisse")
def save_ergebnis(daten: ErgebnisCreate):
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO waldbrand_ergebnisse 
                (username, bundesland, gemeinde, latitude, longitude, wahrscheinlichkeit_prozent)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (
                daten.username, daten.bundesland, daten.gemeinde,
                daten.latitude, daten.longitude, daten.wahrscheinlichkeit_prozent
            ))
            conn.commit()
        return {"message": "Ergebnis gespeichert"}
    finally:
        conn.close()

@app.get("/ergebnisse/{username}")
def get_ergebnisse(username: str, bundesland: Optional[str] = None):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            if bundesland:
                cur.execute("""
                    SELECT bundesland, gemeinde, latitude, longitude, wahrscheinlichkeit_prozent, abfrage_zeit
                    FROM waldbrand_ergebnisse
                    WHERE username = %s AND bundesland = %s
                    ORDER BY abfrage_zeit DESC
                """, (username, bundesland))
            else:
                cur.execute("""
                    SELECT bundesland, gemeinde, latitude, longitude, wahrscheinlichkeit_prozent, abfrage_zeit
                    FROM waldbrand_ergebnisse
                    WHERE username = %s
                    ORDER BY abfrage_zeit DESC
                """, (username,))
            rows = cur.fetchall()
        return rows
    finally:
        conn.close()
