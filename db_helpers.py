import hashlib
import json
import pandas as pd
import psycopg2
import pandas as pd



def trigger_ai_pipeline(conn, username, bundesland):
    """
    Dummy-Funktion für die Pipeline deines Kollegen.
    Dein Kollege muss hier:
    1. Die 14-Tage-Wetterdaten holen.
    2. Das KI-Modell füttern.
    3. Die Ergebnisse per INSERT in die Tabelle 'waldbrand_vorhersagen' schreiben.
    """
    # Das ist für Dich. 
    # Wichtig = folgendes INSERT-Format:
    #
    # cursor.execute(
    #     "INSERT INTO waldbrand_vorhersagen (username, bundesland, koordinaten, gemeinde_bezeichnung, waldbrand_ja_nein, wahrscheinlichkeit) VALUES (%s, %s, point(%s, %s), %s, %s, %s)",
    #     (username, bundesland, laengengrad, breitengrad, gemeinde, waldbrand_bool, wahrscheinlichkeit_float)
    # )
    pass
def init_db(conn):
    """Erstellt alle benötigten Tabellen und setzt fehlerhafte Transaktionen zurück."""
    try:
        with conn.cursor() as cursor:
            # 1. Benutzertabelle
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS users (
                    username TEXT PRIMARY KEY,
                    password_hash TEXT NOT NULL
                );
                """
            )
            # 2. Historientabelle für SQL-Abfragen
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS query_history (
                    id SERIAL PRIMARY KEY,
                    username TEXT REFERENCES users(username) ON DELETE CASCADE,
                    sql_query TEXT NOT NULL,
                    query_result TEXT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                """
            )
            # 3. Ihre bestehende Ergebnis-Tabelle
            cursor.execute(
                """
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
                """
            )
            conn.commit()
    except Exception as e:
        conn.rollback()
        raise e

def get_ai_results(conn, username, bundesland=None):
    """Holt die KI-Ergebnisse aus der Tabelle waldbrand_ergebnisse."""
    colnames = ["bundesland", "gemeinde", "latitude", "longitude", "wahrscheinlichkeit_prozent", "abfrage_zeit"]
    try:
        with conn.cursor() as cursor:
            if bundesland:
                query = """
                    SELECT bundesland, 
                           gemeinde, 
                           latitude, 
                           longitude, 
                           wahrscheinlichkeit_prozent,
                           abfrage_zeit
                    FROM waldbrand_ergebnisse
                    WHERE username = %s AND bundesland = %s
                    ORDER BY abfrage_zeit DESC;
                """
                cursor.execute(query, (username, bundesland))
            else:
                query = """
                    SELECT bundesland, 
                           gemeinde, 
                           latitude, 
                           longitude, 
                           wahrscheinlichkeit_prozent,
                           abfrage_zeit
                    FROM waldbrand_ergebnisse
                    WHERE username = %s
                    ORDER BY abfrage_zeit DESC;
                """
                cursor.execute(query, (username,))
                
            rows = cursor.fetchall()
            
        df = pd.DataFrame(rows, columns=colnames)
        
        if not df.empty:
            # Leitet Ja/Nein automatisch aus der Prozentzahl ab (>= 50% -> Ja)
            df["waldbrand_ja_nein"] = df["wahrscheinlichkeit_prozent"].apply(
                lambda x: "🔴 Ja" if x >= 50 else "🟢 Nein"
            )
            # Formatiert die Zahl schön als Prozent-Text (z. B. "78%")
            df["wahrscheinlichkeit_anzeige"] = df["wahrscheinlichkeit_prozent"].apply(lambda x: f"{x}%")
            
        return df
    except Exception as e:
        conn.rollback()
        raise e


def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def user_exists(conn, username):
    with conn.cursor() as cursor:
        # Psycopg2 nutzt %s als Platzhalter
        cursor.execute("SELECT 1 FROM users WHERE username = %s", (username,))
        result = cursor.fetchone()
        return result is not None

def register_user(conn, username, password):
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO users (username, password_hash) VALUES (%s, %s)",
                (username, hash_password(password))
            )
            conn.commit()
        return True
    except Exception:
        return False

def check_login(conn, username, password):
    with conn.cursor() as cursor:
        cursor.execute("SELECT password_hash FROM users WHERE username = %s", (username,))
        result = cursor.fetchone()
        if result and result[0] == hash_password(password):
            return True
        return False

def save_query(conn, username, sql_query, result_data):
    """Speichert eine SQL-Abfrage und das Ergebnis als JSON-String für einen Nutzer."""
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                """
                INSERT INTO query_history (username, sql_query, query_result) 
                VALUES (%s, %s, %s)
                """,
                (username, sql_query, json.dumps(result_data))
            )
            conn.commit()
        return True
    except Exception:
        return False

def get_user_history(conn, username):
    """Holt die gesamte Historie eines bestimmten Nutzers."""
    with conn.cursor() as cursor:
        cursor.execute(
            """
            SELECT sql_query, query_result, created_at 
            FROM query_history 
            WHERE username = %s 
            ORDER BY created_at DESC
            """,
            (username,)
        )
        result = cursor.fetchall()
        return result

  #
def init_wetter_table(conn):
    with conn.cursor() as cur:
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
  
