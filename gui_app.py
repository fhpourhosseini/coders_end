import os
import streamlit as st

import psycopg2
# Importiere die Funktionen aus der zweiten Datei
import db_helpers as db

st.set_page_config(page_title="Datenbank Analyse", page_icon="🔐")

# Funktion, um die Verbindung nativ via psycopg2 herzustellen
@st.cache_resource # Verhindert, dass Streamlit bei jedem Klick eine neue Verbindung öffnet
def get_native_connection():
    return psycopg2.connect(
        host="db-container", # Entspricht dem Service-Namen in docker-compose
        database=os.getenv("STREAMLIT_CONNECTIONS_POSTGRESQL_DATABASE", "analyse_db"),
        user=os.getenv("STREAMLIT_CONNECTIONS_POSTGRESQL_USERNAME", "postgres"),
        password=os.getenv("STREAMLIT_CONNECTIONS_POSTGRESQL_PASSWORD", "super_sicheres_passwort"),
        port="5432"
    )

# Verbindung zur PostgreSQL-Datenbank herstellen
try:
    conn = get_native_connection()
    db.init_db(conn)
except Exception as e:
    st.error("Verbindung zur PostgreSQL-Datenbank fehlgeschlagen!")
    st.exception(e) # Zeigt euch Entwicklern den genauen Fehler
    st.stop()

if "logged_in" not in st.session_state:
    st.session_state["logged_in"] = False
if "username" not in st.session_state:
    st.session_state["username"] = ""

# LOGIN / REGISTRIERUNG OBERFLÄCHE
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
                st.rerun()
            else:
                st.error("Falscher Nutzername oder falsches Kennwort.")
                
    with tab2:
        st.subheader("Registrieren")
        reg_user = st.text_input("Wunsch-Nutzername", key="reg_user_input")
        reg_pass = st.text_input("Wunsch-Kennwort", type="password", key="reg_pass_input")
        
        if st.button("Registrieren"):
            if db.user_exists(conn, reg_user):
                st.error(f"Der Nutzername **{reg_user}** ist schon vergeben.")
            elif db.register_user(conn, reg_user, reg_pass):
                st.success("Registrierung erfolgreich! Bitte einloggen.")

# HAUPTSEITE (EINGELOGGT)
else:
    username = st.session_state["username"]
    
    with st.sidebar:
        st.write(f"Eingeloggt als: **{username}**")
        if st.button("Abmelden"):
            st.session_state["logged_in"] = False
            st.session_state["username"] = ""
            st.rerun()

    st.title("Datenbank-Analysetool")
    st.write("Hello World")
    
    st.markdown("---")
    st.subheader("Neue Abfrage simulieren")
    
    # Beispiel-Eingabe, um die Historie zu testen
    sim_query = st.text_area("SQL-Abfrage", "SELECT * FROM sales WHERE region = 'West';")
    sim_result = st.text_input("Ergebnis (Simuliert)", "143 Zeilen zurückgegeben")
    
    if st.button("Abfrage ausführen & speichern"):
        if db.save_query(conn, username, sim_query, {"status": sim_result}):
            st.success("Abfrage in deiner persönlichen Historie gespeichert!")
            st.rerun()

    st.markdown("---")
    st.subheader(f"Deine Abfragehistorie ({username})")
    
    history = db.get_user_history(conn, username)
    if history:
        for row in history:
            with st.expander(f"Abfrage vom {row[2].strftime('%d.%m.%Y %H:%M:%S')}"):
                st.code(row[0], language="sql")
                st.json(row[1])
    else:
        st.info("Du hast noch keine Abfragen gespeichert.")
