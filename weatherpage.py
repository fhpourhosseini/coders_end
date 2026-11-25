
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
# API-FUNKTION
# ==========================================

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

    ansichts_modus = st.radio(
        "Darstellungsform wählen:",
        options=["📋 Tabelle", "🗺️ Interaktive Karte"],
        horizontal=True,
        label_visibility="collapsed"
    )

    # ==========================================
    # TABELLENANSICHT
    # ==========================================

    if ansichts_modus == "📋 Tabelle":
        st.markdown("### 📋 Waldbrand-Ergebnisse")

        # Diese Spalte ist fix und kann nicht abgewählt werden.
        fixe_spalten = {
            "Bundesland": "bundesland"
        }

        # Diese Spalten können über das Popup-Menü ein- und ausgeblendet werden.
        optionale_spalten = {
            "Gemeinde": "gemeinde",
            "Breitengrad (Lat)": "latitude",
            "Längengrad (Lon)": "longitude",
            "Waldbrand (Ja/Nein)": "waldbrand_ja_nein",
            "KI-Wahrscheinlichkeit": "wahrscheinlichkeit_anzeige",
            "Zeitpunkt": "abfrage_zeit"
        }

        # Nur Spalten berücksichtigen, die tatsächlich von der API geliefert wurden.
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

        # Checkbox-Zustände beim ersten Aufruf auf True setzen.
        # Bereits vorhandene Benutzerauswahlen bleiben erhalten.
        for spalte in verfuegbare_optionale_spalten.values():
            state_key = f"spaltenauswahl_{spalte}"
            if state_key not in st.session_state:
                st.session_state[state_key] = True

        # Popup-Menü und CSV-Download rechts oberhalb der Tabelle.
        _platzhalter, col_popup, col_csv = st.columns([6, 1, 2])

        with col_popup:
            with st.popover("⚙️ Spalten", use_container_width=True):
                st.write("**Spalten anzeigen:**")

                if verfuegbare_fixe_spalten:
                    st.caption("Bundesland ist fix eingeblendet.")

                for name, spalte in verfuegbare_optionale_spalten.items():
                    state_key = f"spaltenauswahl_{spalte}"
                    st.checkbox(name, key=state_key)

        # Nach dem Erzeugen der Checkboxen den aktuellen Zustand auslesen.
        # Die fixe Spalte wird immer zuerst eingefügt.
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

        # CSV-Datei mit denselben Spalten erstellen, die in der Tabelle sichtbar sind.
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

            st.caption(
                "Die Punkte markieren die analysierten Gemeinden:"
            )
            st.map(df_map)

        except Exception as map_err:
            st.error(
                f"Fehler bei der Kartendarstellung: {map_err}"
            )


# ==========================================
# DASHBOARD
# ==========================================

def show_dashboard(username: str):

    # ==========================================
    # SESSION STATES INITIALISIEREN
    # ==========================================

    if "aktuelle_ansicht" not in st.session_state:
        st.session_state["aktuelle_ansicht"] = "wetter"

    if "ausgewaehltes_bundesland" not in st.session_state:
        st.session_state["ausgewaehltes_bundesland"] = None

    if "bereits_analysiert" not in st.session_state:
        st.session_state["bereits_analysiert"] = None

    # ==========================================
    # SIDEBAR
    # ==========================================

    with st.sidebar:

        st.write(
            f"👤 Eingeloggt als: **{username}**"
        )

        if st.button(
            "Abmelden",
            type="secondary",
            use_container_width=True
        ):

            st.session_state["logged_in"] = False
            st.session_state["username"] = ""
            st.session_state["bereits_analysiert"] = None
            st.session_state["ausgewaehltes_bundesland"] = None

            st.rerun()

        st.markdown("---")

    # ==========================================
    # HAUPTLAYOUT
    # ==========================================

    col_links, col_rechts = st.columns(
        [1, 2],
        gap="large"
    )

    # ==========================================
    # LINKE SEITE: STEUERUNG
    # ==========================================

    with col_links:

        st.subheader("Steuerung")

        ansicht = st.radio(
            "Modus wählen:",
            options=[
                "🔥 Aktuelle Analyse",
                "⏳ Meine Historie"
            ],
            label_visibility="collapsed"
        )

        st.session_state["aktuelle_ansicht"] = (
            "wetter"
            if ansicht == "🔥 Aktuelle Analyse"
            else "history"
        )

        st.markdown("---")

        # ==========================================
        # AKTUELLE ANALYSE
        # ==========================================

        if st.session_state["aktuelle_ansicht"] == "wetter":

            bundeslaender = [
                "Wien",
                "Niederösterreich",
                "Oberösterreich",
                "Steiermark",
                "Tirol",
                "Kärnten",
                "Salzburg",
                "Vorarlberg",
                "Burgenland"
            ]

            auswahl = st.selectbox(
                "Bundesland wählen, um Analyse zu starten:",
                options=bundeslaender,
                index=None,
                placeholder="Bundesland auswählen..."
            )

            if auswahl:

                st.session_state[
                    "ausgewaehltes_bundesland"
                ] = auswahl

                if (
                    st.session_state["bereits_analysiert"]
                    != auswahl
                ):

                    fortschritt = st.progress(
                        0,
                        text="Sende Anfrage an Backend-API..."
                    )

                    with st.status(
                        f"Analyse für **{auswahl}** läuft...",
                        expanded=True
                    ) as status:

                        try:

                            st.write(
                                "🚀 Starte KI-Pipeline im Backend..."
                            )

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
                                text=(
                                    "Pipeline gestartet. "
                                    "Warte auf Ergebnisse..."
                                )
                            )

                            st.write(
                                "⏳ KI-Modell berechnet Waldbrandrisiko..."
                            )

                            # Status der Backend-Pipeline abfragen

                            while True:

                                status_resp = requests.get(
                                    f"{API_BASE_URL}/status/{job_id}",
                                    timeout=10
                                )

                                status_resp.raise_for_status()

                                status_data = status_resp.json()

                                current_status = status_data.get(
                                    "status"
                                )

                                # Pipeline erfolgreich abgeschlossen

                                if current_status == "completed":

                                    fortschritt.progress(
                                        100,
                                        text="Fertig!"
                                    )

                                    status.update(
                                        label=(
                                            f"Analyse für {auswahl} "
                                            "abgeschlossen!"
                                        ),
                                        state="complete",
                                        expanded=False
                                    )

                                    st.session_state[
                                        "bereits_analysiert"
                                    ] = auswahl

                                    break

                                # Pipeline fehlgeschlagen

                                elif current_status == "failed":

                                    status.update(
                                        label="Fehler in der KI-Pipeline!",
                                        state="error"
                                    )

                                    st.error(
                                        "Die Berechnung im Backend "
                                        "ist fehlgeschlagen."
                                    )

                                    break

                                # Pipeline läuft noch

                                fortschritt.progress(
                                    65,
                                    text="Berechnung läuft..."
                                )

                                time.sleep(1.5)

                        except requests.exceptions.RequestException as req_err:

                            status.update(
                                label="Verbindungsfehler zur API",
                                state="error"
                            )

                            st.error(
                                f"Backend-API nicht erreichbar: {req_err}"
                            )

    # ==========================================
    # RECHTE SEITE: ANZEIGE
    # ==========================================

    with col_rechts:

        # ==========================================
        # AKTUELLE WALDBRANDANALYSE
        # ==========================================

        if st.session_state["aktuelle_ansicht"] == "wetter":

            st.subheader(
                "🔥 Aktuelle Waldbrandgefahr-Analyse"
            )

            aktuelle_auswahl = st.session_state[
                "ausgewaehltes_bundesland"
            ]

            if aktuelle_auswahl:

                st.markdown(
                    f"Ergebnisse für das Bundesland: "
                    f"**{aktuelle_auswahl}**"
                )

                try:

                    df_ergebnisse = fetch_results_from_api(
                        username,
                        bundesland=aktuelle_auswahl
                    )

                    render_results_modular(
                        df_ergebnisse
                    )

                except Exception as e:

                    st.error(
                        f"Fehler beim Laden der Ergebnisse über API: {e}"
                    )

            else:

                st.info(
                    "Bitte wähle links ein Bundesland aus, "
                    "um die KI-Waldbrandvorhersage zu starten."
                )

        # ==========================================
        # HISTORIE
        # ==========================================

        elif st.session_state["aktuelle_ansicht"] == "history":

            st.subheader(
                "⏳ Deine vergangenen Vorhersagen"
            )

            st.caption(
                "Hier siehst du deine historischen Abfragen."
            )

            try:

                df_historie = fetch_results_from_api(
                    username,
                    bundesland=None
                )

                render_results_modular(
                    df_historie
                )

            except Exception as e:

                st.error(
                    f"Fehler beim Laden der Historie: {e}"
                )