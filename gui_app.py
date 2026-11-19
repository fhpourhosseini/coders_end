import os
import streamlit as st
import requests
from weatherpage import show_dashboard

# 1. Seiteneinstellungen
st.set_page_config(page_title="Waldbrand Analyse", page_icon="🔥", layout="wide")

# FastAPI Basis-URL
API_URL = os.environ.get("FASTAPI_URL", "http://fastapi-container:8000")

# 2. Session State initialisieren
if "logged_in" not in st.session_state:
    st.session_state["logged_in"] = False
if "username" not in st.session_state:
    st.session_state["username"] = ""

# 3. Authentifizierungs-Bereich über FastAPI
if not st.session_state["logged_in"]:
    tab1, tab2 = st.tabs(["Login", "Registrieren"])
    
    
    with tab1:
        st.subheader("Einloggen")
        with st.form("login_form"):
            login_user = st.text_input("Nutzername")
            login_pass = st.text_input("Kennwort", type="password")
            submit_login = st.form_submit_button("Einloggen", type="primary")
        
        if submit_login:
            if not login_user.strip() or not login_pass:
                st.warning("Bitte Nutzername und Kennwort eingeben.")
            else:
                try:
                    res = requests.post(
                        f"{API_URL}/login",
                        json={"username": login_user.strip(), "password": login_pass},
                        timeout=5
                    )
                    if res.status_code == 200:
                        st.session_state["logged_in"] = True
                        st.session_state["username"] = login_user.strip()
                        st.success(f"Willkommen zurück, {login_user.strip()}!")
                        st.rerun()
                    else:
                        try:
                            detail = res.json().get("detail", "Falscher Nutzername oder Kennwort.")
                        except ValueError:
                            detail = f"Serverfehler (Status {res.status_code})"
                        st.error(detail)
                except requests.exceptions.RequestException:
                    st.error("Verbindung zum FastAPI-Server fehlgeschlagen.")

        with tab2:
            st.subheader("Neuen Account erstellen")
            with st.form("register_form"):
                reg_user = st.text_input("Nutzername wählen")
                reg_pass = st.text_input("Kennwort wählen", type="password")
                reg_pass_conf = st.text_input("Kennwort wiederholen", type="password")
                submit_reg = st.form_submit_button("Registrieren")

        if submit_reg:
            if not reg_user.strip() or not reg_pass:
                st.warning("Bitte füllen Sie alle Felder aus.")
            elif reg_pass != reg_pass_conf:
                st.error("Die Kennwörter stimmen nicht überein.")
            else:
                try:
                    res = requests.post(
                        f"{API_URL}/register",
                        json={"username": reg_user.strip(), "password": reg_pass},
                        timeout=5
                    )
                    if res.status_code == 200:
                        st.success("Registrierung erfolgreich! Sie können sich jetzt einloggen.")
                    else:
                        st.error(res.json().get("detail", "Nutzername existiert bereits oder Fehler."))
                except requests.exceptions.RequestException:
                    st.error("Verbindung zum FastAPI-Server fehlgeschlagen.")


# 4. Dashboard mit API_URL statt DB-Verbindung aufrufen
else:
    show_dashboard( st.session_state["username"])
