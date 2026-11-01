import hashlib
import json

def init_db(conn):
    """Erstellt die Benutzer- und Historietabellen."""
    # Nativ nutzt man unter Python immer einen cursor
    with conn.cursor() as cursor:
        # Benutzertabelle
        cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS users (
                username TEXT PRIMARY KEY,
                password_hash TEXT NOT NULL
            );
            """
        )
        # Historientabelle
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
        conn.commit()

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
