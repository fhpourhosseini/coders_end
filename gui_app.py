import os
import streamlit as st
import psycopg2
import db_helpers as db
from weatherpage import show_dashboard

# 1. Seiteneinstellungen (Muss ganz oben stehen)
st.set_page_config(page_title="Waldbrand Analyse", page_icon="🔥", layout="wide")

# 2. Datenbankverbindung cache-optimiert bereitstellen
@st.cache_resource
def get_native_connection():
    return psycopg2.connect(
        host="db-container",
        port="5432",
        database=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_DATABASE"],
        user=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_USERNAME"],
        password=os.environ["STREAMLIT_CONNECTIONS_POSTGRESQL_PASSWORD"]
    )

# 3. DB-Verbindung und Tabellen-Initialisierung
try:
    conn = get_native_connection()
    db.init_db(conn)
    
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
except Exception as e:
    st.error("Verbindung zur PostgreSQL-Datenbank fehlgeschlagen!")
    st.exception(e)
    st.stop()

# 4. Session State initialisieren
if "logged_in" not in st.session_state:
    st.session_state["logged_in"] = False
if "username" not in st.session_state:
    st.session_state["username"] = ""

# 5. Authentifizierungs-Bereich (Login / Registrierung)
if not st.session_state["logged_in"]:
    tab1, tab2 = st.tabs(["Login", "Registrieren"])
    
    with tab1:
        st.subheader("Einloggen")
        login_user = st.text_input("Nutzername", key="login_user_input")
        login_pass = st.text_input("Kennwort", type="password", key="login_pass_input")
        
        if st.button("Einloggen", type="primary"):
            if db.check_login(conn, login_user, login_pass):
                st.session_state["logged_in"] = True
                st.session_state["username"] = login_user
                st.success(f"Willkommen zurück, {login_user}!")
                st.rerun()
            else:
                st.error("Falscher Nutzername oder Kennwort.")
                
    with tab2:
        st.subheader("Neuen Account erstellen")
        reg_user = st.text_input("Nutzername wählen", key="reg_user_input")
        reg_pass = st.text_input("Kennwort wählen", type="password", key="reg_pass_input")
        reg_pass_conf = st.text_input("Kennwort wiederholen", type="password", key="reg_pass_conf_input")
        
        if st.button("Registrieren"):
            if not reg_user or not reg_pass:
                st.warning("Bitte füllen Sie alle Felder aus.")
            elif reg_pass != reg_pass_conf:
                st.error("Die Kennwörter stimmen nicht überein.")
            else:
                # Nutzt die Funktion aus deiner db_helpers.py (nimmt idealerweise conn, user, pass)
                if db.register_user(conn, reg_user, reg_pass):
                    st.success("Registrierung erfolgreich! Sie können sich jetzt einloggen.")
                else:
                    st.error("Nutzername existiert bereits oder Registrierung fehlgeschlagen.")
 # Wenn eingeloggt, zeige direkt das Dashboard aus weather_page.py
else:
    show_dashboard(conn, st.session_state["username"])                   

# 6. Hauptanwendung / Dashboard (Sichtbar nach Login)
#else:
    # Sidebar für Benutzer-Infos und Logout
   # with st.sidebar:
      #  st.write(f"Eingeloggt als: **{st.session_state['username']}**")
      #  if st.button("Ausloggen"):
           # st.session_state["logged_in"] = False
          #  st.session_state["username"] = ""
          #  st.rerun()

    # Hier folgt der Inhalt des Dashboards
    #st.title("🔥 Waldbrand Analyse Dashboard")
   # st.write("Willkommen im Analyse-Tool. Nutzen Sie die Funktionen zur Auswertung.")
    
    # Platzhalter für die eigentliche Pipeline-Logik / Abfragen
