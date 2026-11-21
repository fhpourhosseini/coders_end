import streamlit as st
import pandas as pd
import requests
import time
from ui_css_component import render_styled_table


API_BASE_URL = "http://fastapi-container:8000"


def fetch_results_from_api(username: str, bundesland: str = None) -> pd.DataFrame:
    """Holt die Ergebnisse für einen User (optional gefiltert nach Bundesland) von der FastAPI."""
    params = {}
    if bundesland:
        params["bundesland"] = bundesland

    resp = requests.get(f"{API_BASE_URL}/ergebnisse/{username}", params=params, timeout=10)
    resp.raise_for_status()
    data = resp.json()

    if not data:
        return pd.DataFrame()

    df = pd.DataFrame(data)

    # Falls die Spalten für die Anzeige noch nicht in der API-Antwort aufbereitet sind, hier erzeugen:
    if "waldbrand_ja_nein" not in df.columns and "wahrscheinlichkeit_prozent" in df.columns:
        df["waldbrand_ja_nein"] = df["wahrscheinlichkeit_prozent"].apply(lambda x: "Ja" if x >= 50 else "Nein")
    if "wahrscheinlichkeit_anzeige" not in df.columns and "wahrscheinlichkeit_prozent" in df.columns:
        df["wahrscheinlichkeit_anzeige"] = df["wahrscheinlichkeit_prozent"].apply(lambda x: f"{x} %")

    return df


def show_dashboard(username: str):
    # 1. Session States für die Ansichtssteuerung initialisieren
    if "aktuelle_ansicht" not in st.session_state:
        st.session_state["aktuelle_ansicht"] = "wetter"
    if "ausgewaehltes_bundesland" not in st.session_state:
        st.session_state["ausgewaehltes_bundesland"] = None
    if "bereits_analysiert" not in st.session_state:
        st.session_state["bereits_analysiert"] = None

    # Sidebar: User-Info und Abmeldung
    with st.sidebar:
        st.write(f"👤 Eingeloggt als: **{username}**")
        if st.button("Abmelden", type="secondary", use_container_width=True):
            st.session_state["logged_in"] = False
            st.session_state["username"] = ""
            st.session_state["bereits_analysiert"] = None
            st.session_state["ausgewaehltes_bundesland"] = None
            st.rerun()
        st.markdown("---")

    # Haupt-Layout: Linke Steuerung (1 Teil), Rechte Anzeige (2 Teile)
    col_links, col_rechts = st.columns([1, 2], gap="large")

    # ==========================================
    # LINKE SEITE: STEUERUNG
    # ==========================================
    with col_links:
        st.subheader("Steuerung")

        ansicht = st.radio(
            "Modus wählen:",
            options=["🔥 Aktuelle Analyse", "⏳ Meine Historie"],
            label_visibility="collapsed"
        )
        st.session_state["aktuelle_ansicht"] = "wetter" if ansicht == "🔥 Aktuelle Analyse" else "history"
        st.markdown("---")

        if st.session_state["aktuelle_ansicht"] == "wetter":
            bundeslaender = [
                "Wien", "Niederösterreich", "Oberösterreich", "Steiermark",
                "Tirol", "Kärnten", "Salzburg", "Vorarlberg", "Burgenland"
            ]

            auswahl = st.selectbox(
                "Bundesland wählen, um Analyse zu starten:",
                options=bundeslaender,
                index=None,
                placeholder="Bundesland auswählen..."
            )

            if auswahl:
                st.session_state["ausgewaehltes_bundesland"] = auswahl

                if st.session_state["bereits_analysiert"] != auswahl:
                    fortschritt = st.progress(0, text="Sende Anfrage an Backend-API...")

                    with st.status(f"Analyse für **{auswahl}** läuft...", expanded=True) as status:
                        try:
                            st.write("🚀 Starte KI-Pipeline im Backend...")
                            start_resp = requests.post(
                                f"{API_BASE_URL}/start",
                                json={"username": username, "bundesland": auswahl},
                                timeout=10
                            )
                            start_resp.raise_for_status()
                            job_id = start_resp.json()["job_id"]

                            fortschritt.progress(30, text="Pipeline gestartet. Warte auf Ergebnisse...")
                            st.write("⏳ KI-Modell berechnet Waldbrandrisiko...")

                            while True:
                                status_resp = requests.get(f"{API_BASE_URL}/status/{job_id}", timeout=10)
                                status_resp.raise_for_status()
                                status_data = status_resp.json()
                                current_status = status_data.get("status")

                                if current_status == "completed":
                                    fortschritt.progress(100, text="Fertig!")
                                    status.update(label=f"Analyse für {auswahl} abgeschlossen!", state="complete", expanded=False)
                                    st.session_state["bereits_analysiert"] = auswahl
                                    break
                                elif current_status == "failed":
                                    status.update(label="Fehler in der KI-Pipeline!", state="error")
                                    st.error("Die Berechnung im Backend ist fehlgeschlagen.")
                                    break

                                fortschritt.progress(65, text="Berechnung läuft...")
                                time.sleep(1.5)

                        except requests.exceptions.RequestException as req_err:
                            status.update(label="Verbindungsfehler zur API", state="error")
                            st.error(f"Backend-API nicht erreichbar: {req_err}")

    # ==========================================
    # RECHTE SEITE: ANZEIGE
    # ==========================================
        # ==========================================
    # RECHTE SEITE: ANZEIGE
    # ==========================================
    with col_rechts:

        def render_results_modular(df_data):
            if df_data.empty:
                st.warning("Keine Daten für die Anzeige vorhanden.")
                return

            ansichts_modus = st.radio(
                "Darstellungsform wählen:",
                options=["📋 Tabelle", "🗺️ Interaktive Karte"],
                horizontal=True,
                label_visibility="collapsed"
            )

            if ansichts_modus == "📋 Tabelle":
                df_display = df_data[[
                    "bundesland", "gemeinde", "latitude", "longitude",
                    "waldbrand_ja_nein", "wahrscheinlichkeit_anzeige", "abfrage_zeit"
                ]].copy()

                df_display.columns = [
                    "Bundesland", "Gemeinde", "Breitengrad (Lat)", "Längengrad (Lon)",
                    "Waldbrand (Ja/Nein)", "KI-Wahrscheinlichkeit", "Zeitpunkt"
                ]

                render_styled_table(df_display)

            elif ansichts_modus == "🗺️ Interaktive Karte":
                try:
                    df_map = df_data[["latitude", "longitude"]].dropna().copy()
                    df_map["latitude"] = pd.to_numeric(df_map["latitude"])
                    df_map["longitude"] = pd.to_numeric(df_map["longitude"])

                    st.caption("Die roten Punkte markieren die analysierten Gemeinden:")
                    st.map(df_map)
                except Exception as map_err:
                    st.error(f"Fehler bei der Kartendarstellung: {map_err}")

        # ------------------------------------------
        # WETTER / AKTUELLES BUNDESLAND
        # ------------------------------------------
        if st.session_state["aktuelle_ansicht"] == "wetter":
            st.subheader("🔥 Aktuelle Waldbrandgefahr-Analyse")

            aktuelle_auswahl = st.session_state["ausgewaehltes_bundesland"]

            if aktuelle_auswahl:
                st.markdown(f"Ergebnisse für das Bundesland: **{aktuelle_auswahl}**")
                try:
                    df_ergebnisse = fetch_results_from_api(username, bundesland=aktuelle_auswahl)
                    render_results_modular(df_ergebnisse)
                except Exception as e:
                    st.error(f"Fehler beim Laden der Ergebnisse über API: {e}")
            else:
                st.info("Bitte wähle links ein Bundesland aus, um die KI-Waldbrandvorhersage zu starten.")

        # ------------------------------------------
        # HISTORIE (NUR EIGENE DATEN)
        # ------------------------------------------
        elif st.session_state["aktuelle_ansicht"] == "history":
            st.subheader("⏳ Deine vergangenen Vorhersagen")
            st.caption("Hier siehst du deine historischen Abfragen.")

            try:
                df_historie = fetch_results_from_api(username, bundesland=None)
                render_results_modular(df_historie)
            except Exception as e:
                st.error(f"Fehler beim Laden der Historie über API: {e}")
