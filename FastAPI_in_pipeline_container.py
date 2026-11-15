import os
import time
import uuid
import psycopg2
from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel

app = FastAPI()

# Modell für die Daten, die vom Streamlit-Frontend geschickt werden
class PipelineRequest(BaseModel):
    username: str
    bundesland: str

def get_db_connection():
    # Nutzt dieselben Umgebungsvariablen/Zugangsdaten wie das Frontend!
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "db-container"),
        port="5432",
        database=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_DATABASE"],
        user=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_USERNAME"],
        password=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_PASSWORD"]
    )

def run_ai_pipeline(job_id: str, username: str, bundesland: str):
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # 1. Hier läuft später die echte Wetter- & KI-Pipeline für `bundesland`
        time.sleep(3)  # Mock-Verzögerung
        
        # Mock-Ergebnisse für Gemeinden (wird später durch echte KI-Outputs ersetzt)
        mock_ergebnisse = [
            (username, bundesland, "Beispielgemeinde Nord", 48.2082, 16.3738, 78),
            (username, bundesland, "Beispielgemeinde Süd", 48.1500, 16.3000, 24),
        ]
        
        # 2. Ergebnisse in die Tabelle schreiben, die das Frontend ausliest!
        cur.executemany(
            """
            INSERT INTO waldbrand_ergebnisse 
                (username, bundesland, gemeinde, latitude, longitude, wahrscheinlichkeit_prozent) 
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            mock_ergebnisse
        )
        
        # 3. Job-Status auf "completed" setzen
        cur.execute(
            "UPDATE pipeline_jobs SET status = %s WHERE job_id = %s",
            ("completed", job_id)
        )
        conn.commit()
    except Exception as e:
        conn.rollback()
        cur.execute(
            "UPDATE pipeline_jobs SET status = %s WHERE job_id = %s",
            ("failed", job_id)
        )
        conn.commit()
    finally:
        cur.close()
        conn.close()

@app.post("/start")
def start_pipeline(req: PipelineRequest, background_tasks: BackgroundTasks):
    job_id = str(uuid.uuid4())
    
    conn = get_db_connection()
    cur = conn.cursor()
    # Tabelle anlegen, falls sie noch nicht existiert
    cur.execute("""
        CREATE TABLE IF NOT EXISTS pipeline_jobs (
            job_id VARCHAR(50) PRIMARY KEY,
            status VARCHAR(20),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)
    cur.execute(
        "INSERT INTO pipeline_jobs (job_id, status) VALUES (%s, %s)",
        (job_id, "running")
    )
    conn.commit()
    cur.close()
    conn.close()
    
    # Pipeline asynchron mit username & bundesland starten
    background_tasks.add_task(run_ai_pipeline, job_id, req.username, req.bundesland)
    return {"job_id": job_id, "status": "running"}

@app.get("/status/{job_id}")
def check_status(job_id: str):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        "SELECT status FROM pipeline_jobs WHERE job_id = %s",
        (job_id,)
    )
    row = cur.fetchone()
    cur.close()
    conn.close()
    
    if row:
        return {"status": row[0]}
    return {"status": "not_found"}
