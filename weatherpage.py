import streamlit as st
import pandas as pd
import requests
import time
from ui_css_component import render_styled_table


# ==========================================
# SEITENKONFIGURATION
# ==========================================

st.set_page_config(
    page_title="Waldbrandgefahr-Analyse",
    layout="wide"
)

API_BASE_URL = "http://fastapi-container:8000"


# ==========================================
# HILFSFUNKTIONEN
# ==========================================

def toggle_vollbild():
    st.session_state["tabelle_vollbild"] = not st.session_state.get(
        "tabelle_vollbild", False
    )


def fetch_results_from_api(
    username: str,
    bundesland: str = None
) -> pd.DataFrame:

    params = {}

    if bundesland:
        params["bundesland"] = bundesland

    resp = requests.get(
        f"{API_BASE_URL}/ergebnisse/{username}",
        params=params,
        timeout=10
    )

    resp.raise_for_status()
    data = resp.json()

    if not data:
        return pd.DataFrame()

    df = pd.DataFrame(data)

    if (
        "waldbrand_ja_nein" not in df.columns
        and "wahrscheinlichkeit_prozent" in df.columns
    ):
        df["waldbrand_ja_nein"] = df[
            "wahrscheinlichkeit_prozent"
        ].apply(
            lambda x: "Ja" if x >= 50 else "Nein"
        )

    if (
        "wahrscheinlichkeit_anzeige" not in df.columns
        and "wahrscheinlichkeit_prozent" in df.columns
    ):
        df["wahrscheinlichkeit_anzeige"] = df[
            "wahrscheinlichkeit_prozent"
        ].apply(
            lambda x: f"{x} %"
        )

    return df


# ==========================================
# MODULARE ERGEBNISDARSTELLUNG
# ==========================================

def render_results_modular(df_data):
    """Zeigt die Ergebnisse wahlweise als Tabelle oder als Karte an."""

    if df_data.empty:
        st.warning("Keine Daten für die Anzeige vorhanden.")
        return

    # Obere Leiste: Links Darstellungsform, rechts Vollbild-Button
    col_radio, col_fullscreen = st.columns([4, 1])

    with col_radio:
        ansichts_modus = st.radio(
            "Darstellungsform wählen:",
            options=["📋 Tabelle", "🗺️ Interaktive Karte"],
            horizontal=True,
            label_visibility="collapsed"
        )

    with col_fullscreen:
        btn_label = (
            "↙️ Verkleinern"
            if st.session_state.get("tabelle_vollbild", False)
            else "↗️ Vollbild"
        )
        st.button(
            btn_label,
            on_click=toggle_vollbild,
            use_container_width=True
        )

    # ==========================================
    # TABELLENANSICHT
    # ==========================================

    if ansichts_modus == "📋 Tabelle":
        st.markdown("### 📋 Waldbrand-Ergebnisse")

        fixe_spalten = {
            "Bundesland": "bundesland"
        }

        optionale_spalten = {
            "Gemeinde": "gemeinde",
            "Breitengrad (Lat)": "latitude",
            "Längengrad (Lon)": "longitude",
            "Waldbrand (Ja/Nein)": "waldbrand_ja_nein",
            "KI-Wahrscheinlichkeit": "wahrscheinlichkeit_anzeige",
            "Zeitpunkt": "abfrage_zeit"
        }

        verfuegbare_fixe_spalten = {
            name: spalte
            for name, spalte in fixe_spalten.items()
            if spalte in df_data.columns
        }

        verfuegbare_optionale_spalten = {
            name: spalte
            for name, spalte in optionale_spalten.items()
            if spalte in df_data.columns
        }

        for spalte in verfuegbare_optionale_spalten.values():
            state_key = f"spaltenauswahl_{spalte}"
            if state_key not in st.session_state:
                st.session_state[state_key] = True

        _platzhalter, col_popup, col_csv = st.columns([6, 1, 2])

        with col_popup:
            with st.popover("⚙️ Spalten", use_container_width=True):
                st.write("**Spalten anzeigen:**")

                if verfuegbare_fixe_spalten:
                    st.caption("Bundesland ist fix eingeblendet.")

                for name, spalte in verfuegbare_optionale_spalten.items():
                    state_key = f"spaltenauswahl_{spalte}"
                    st.checkbox(name, key=state_key)

        ausgewaehlte_spalten = list(verfuegbare_fixe_spalten.values())

        for name, spalte in verfuegbare_optionale_spalten.items():
            state_key = f"spaltenauswahl_{spalte}"
            if st.session_state.get(state_key, True):
                ausgewaehlte_spalten.append(spalte)

        if not ausgewaehlte_spalten:
            st.info(
                "Es sind keine anzeigbaren Spalten vorhanden. "
                "Bitte prüfe die Daten aus der API."
            )
            return

        deutsche_namen = {
            "bundesland": "Bundesland",
            "gemeinde": "Gemeinde",
            "latitude": "Breitengrad (Lat)",
            "longitude": "Längengrad (Lon)",
            "waldbrand_ja_nein": "Waldbrand (Ja/Nein)",
            "wahrscheinlichkeit_anzeige": "KI-Wahrscheinlichkeit",
            "abfrage_zeit": "Zeitpunkt"
        }

        df_display = df_data[ausgewaehlte_spalten].copy()
        df_display.columns = [
            deutsche_namen.get(spalte, spalte)
            for spalte in ausgewaehlte_spalten
        ]

        csv_daten = df_display.to_csv(
            index=False,
            sep=";"
        ).encode("utf-8-sig")

        with col_csv:
            st.download_button(
                label="📥 CSV herunterladen",
                data=csv_daten,
                file_name="Waldbrand_Analyse.csv",
                mime="text/csv",
                use_container_width=True
            )

        render_styled_table(df_display)

    # ==========================================
    # KARTENANSICHT
    # ==========================================

    elif ansichts_modus == "🗺️ Interaktive Karte":
        try:
            benoetigte_spalten = ["latitude", "longitude"]
            fehlende_spalten = [
                spalte
                for spalte in benoetigte_spalten
                if spalte not in df_data.columns
            ]

            if fehlende_spalten:
                st.warning(
                    "Die Karte kann nicht angezeigt werden. "
                    "Es fehlen die Spalten: "
                    + ", ".join(fehlende_spalten)
                )
                return

            df_map = df_data[benoetigte_spalten].copy()
            df_map["latitude"] = pd.to_numeric(
                df_map["latitude"],
                errors="coerce"
            )
            df_map["longitude"] = pd.to_numeric(
                df_map["longitude"],
                errors="coerce"
            )
            df_map = df_map.dropna(subset=benoetigte_spalten)

            if df_map.empty:
                st.info(
                    "Es sind keine gültigen Koordinaten für die Karte vorhanden."
                )
                return

            st.caption("Die Punkte markieren die analysierten Gemeinden:")
            st.map(df_map)

        except Exception as map_err:
            st.error(f"Fehler bei der Kartendarstellung: {map_err}")


# ==========================================
# DASHBOARD
# ==========================================

def show_dashboard(username: str):

    # Session States initialisieren
    if "aktuelle_ansicht" not in st.session_state:
        st.session_state["aktuelle_ansicht"] = "wetter"

    if "ausgewaehltes_bundesland" not in st.session_state:
        st.session_state["ausgewaehltes_bundesland"] = None

    if "bereits_analysiert" not in st.session_state:
        st.session_state["bereits_analysiert"] = None

    if "tabelle_vollbild" not in st.session_state:
        st.session_state["tabelle_vollbild"] = False

    # Sidebar
    with st.sidebar:
        st.write(f"👤 Eingeloggt als: **{username}**")

        if st.button(
            "Abmelden",
            type="secondary",
            use_container_width=True
        ):
            st.session_state["logged_in"] = False
            st.session_state["username"] = ""
            st.session_state["bereits_analysiert"] = None
            st.session_state["ausgewaehltes_bundesland"] = None
            st.session_state["tabelle_vollbild"] = False
            st.rerun()

        st.markdown("---")

    # Hauptlayout (Vollbild vs. 2 Spalten)
    if st.session_state["tabelle_vollbild"]:
        col_rechts = st.container()
        col_links = None
    else:
        col_links, col_rechts = st.columns([1, 2], gap="large")

    # Linke Seite: Steuerung (nur sichtbar, wenn nicht im Vollbild)
    if col_links is not None:
        with col_links:
            st.subheader("Steuerung")

            ansicht = st.radio(
                "Modus wählen:",
                options=[
                    "🔥 Aktuelle Analyse",
                    "⏳ Meine Historie"
                ],
                index=0 if st.session_state["aktuelle_ansicht"] == "wetter" else 1,
                label_visibility="collapsed"
            )

            st.session_state["aktuelle_ansicht"] = (
                "wetter"
                if ansicht == "🔥 Aktuelle Analyse"
                else "history"
            )

            st.markdown("---")

            if st.session_state["aktuelle_ansicht"] == "wetter":
                bundeslaender = [
                    "Wien", "Niederösterreich", "Oberösterreich",
                    "Steiermark", "Tirol", "Kärnten",
                    "Salzburg", "Vorarlberg", "Burgenland"
                ]

                auswahl = st.selectbox(
                    "Bundesland wählen, um Analyse zu starten:",
                    options=bundeslaender,
                    index=None,
                    placeholder="Bundesland auswählen..."
                )

                if auswahl:
                    st.session_state["ausgewaehltes_bundesland"] = auswahl

                    # ---> HIER GEHT ES WEITER <---
                    if st.session_state["bereits_analysiert"] != auswahl:
                        fortschritt = st.progress(
                            0,
                            text="Sende Anfrage an Backend-API..."
                        )

                        with st.status(
                            f"Analyse für **{auswahl}** läuft...",
                            expanded=True
                        ) as status:
                            try:
                                st.write("🚀 Starte KI-Pipeline im Backend...")

                                start_resp = requests.post(
                                    f"{API_BASE_URL}/start",
                                    json={
                                        "username": username,
                                        "bundesland": auswahl
                                    },
                                    timeout=10
                                )
                                start_resp.raise_for_status()
                                job_id = start_resp.json()["job_id"]

                                fortschritt.progress(
                                    30,
                                    text="Pipeline gestartet. Warte auf Ergebnisse..."
                                )
                                st.write("⏳ KI-Modell berechnet Waldbrandrisiko...")

                                while True:
                                    status_resp = requests.get(
                                        f"{API_BASE_URL}/status/{job_id}",
                                        timeout=10
                                    )
                                    status_resp.raise_for_status()
                                    status_data = status_resp.json()
                                    current_status = status_data.get("status")

                                    if current_status == "completed":
                                        fortschritt.progress(100, text="Fertig!")
                                        status.update(
                                            label=f"Analyse für {auswahl} abgeschlossen!",
                                            state="complete",
                                            expanded=False
                                        )
                                        st.session_state["bereits_analysiert"] = auswahl
                                        break

                                    elif current_status == "failed":
                                        status.update(
                                            label="Fehler in der KI-Pipeline!",
                                            state="error"
                                        )
                                        st.error(
                                            "Die Berechnung im Backend ist fehlgeschlagen."
                                        )
                                        break

                                    fortschritt.progress(65, text="Berechnung läuft...")
                                    time.sleep(1.5)

                            except requests.exceptions.RequestException as req_err:
                                status.update(
                                    label="Verbindungsfehler zur API",
                                    state="error"
                                )
                                st.error(f"Backend-API nicht erreichbar: {req_err}")

    # ==========================================
    # RECHTE SEITE: ERGEBNISSE LADEN & ANZEIGEN
    # ==========================================
    with col_rechts:
        try:
            if st.session_state["aktuelle_ansicht"] == "wetter":
                bundesland = st.session_state["ausgewaehltes_bundesland"]
                if bundesland:
                    df_ergebnisse = fetch_results_from_api(username, bundesland)
                    render_results_modular(df_ergebnisse)
                else:
                    st.info("👈 Bitte wähle links ein Bundesland für die Analyse aus.")
            else:
                df_historie = fetch_results_from_api(username)
                render_results_modular(df_historie)

        except Exception as e:
            st.error(f"Fehler beim Laden der Ergebnisse: {e}")
