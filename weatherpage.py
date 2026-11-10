import streamlit as st
import pandas as pd
import db_helpers as db
import time

def show_dashboard(conn, username):
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
            st.rerun()
        st.markdown("---")

    # Haupt-Layout: Linke Steuerung (1 Teil), Rechte Anzeige (2 Teile)
    col_links, col_rechts = st.columns([1, 2], gap="large")

    # ==========================================
    # LINKE SEITE: STEUERUNG
    # ==========================================
    with col_links:
        st.subheader("Steuerung")
        
        # Umschalter zwischen aktueller Analyse und Historie
        ansicht = st.radio(
            "Modus wählen:",
            options=["🔥 Aktuelle Analyse", "⏳ Meine Historie"],
            label_visibility="collapsed"
        )
        st.session_state["aktuelle_ansicht"] = "wetter" if ansicht == "🔥 Aktuelle Analyse" else "history"
        st.markdown("---")

        # Bundesland-Auswahl nur anzeigen, wenn wir im Analyse-Modus sind
        if st.session_state["aktuelle_ansicht"] == "wetter":
            bundeslaender = [
                "Wien", "Niederösterreich", "Oberösterreich", "Steiermark", 
                "Tirol", "Kärnten", "Salzburg", "Vorarlberg", "Burgenland"
            ]

            auswahl = st.selectbox(
                "Bundesland wählen, um Analyse zu starten:",
                options=bundeslaender,
                index=None,
                placeholder="Bitte Bundesland auswählen..."
            )

            if auswahl:
                st.session_state["ausgewaehltes_bundesland"] = auswahl
                
                # Pipeline nur dann ausführen, wenn ein NEUES Bundesland gewählt wurde
                if st.session_state["bereits_analysiert"] != auswahl:
                    fortschritt = st.progress(0, text="Starte Pipeline...")
                    
                    with st.status(f"Analyse für **{auswahl}** läuft...", expanded=True) as status:
                        st.write("📥 Lade aktuelle Wetterdaten...")
                        # TODO: Hier echten DB-Aufruf einfügen
                        time.sleep(0.8) 
                        fortschritt.progress(33, text="Daten geladen. Bereite Features auf...")
                        
                        st.write("⚙️ Verarbeite Daten in der Pipeline...")
                        # TODO: Hier echte Pipeline-Logik einfügen
                        time.sleep(0.8)
                        fortschritt.progress(66, text="Pipeline fertig. Starte KI-Modell...")
                        
                        st.write("🤖 Berechne KI-Vorhersage...")
                        # TODO: Hier echtes KI-Modell & Speichern in DB einfügen
                        time.sleep(0.8)
                        fortschritt.progress(100, text="Fertig!")
                        
                        status.update(label=f"Analyse für {auswahl} abgeschlossen!", state="complete", expanded=False)
                    
                    # Merken, dass dieses Bundesland gerade analysiert wurde
                    st.session_state["bereits_analysiert"] = auswahl

    # ==========================================
    # RECHTE SEITE: ANZEIGE
    # ==========================================
    with col_rechts:
        
        # Hilfsfunktion zur Darstellung der Daten (Tabelle oder Karte)
                # Hilfsfunktion zur Darstellung der Daten (Tabelle oder Karte)
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
                    "bundesland", "gemeinde", "latitude", "longitude", "waldbrand_ja_nein", "wahrscheinlichkeit_anzeige", "abfrage_zeit"
                ]].copy()
                df_display.columns = [
                    "Bundesland", "Gemeinde", "Breitengrad (Lat)", "Längengrad (Lon)", "Waldbrand (Ja/Nein)", "KI-Wahrscheinlichkeit", "Zeitpunkt"
                ]
                st.dataframe(df_display, use_container_width=True)
                
            elif ansichts_modus == "🗺️ Interaktive Karte":
                try:
                    # Streamlit st.map erkennt die Spalten 'latitude' und 'longitude' automatisch!
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
                    df_ergebnisse = db.get_ai_results(conn, username, bundesland=aktuelle_auswahl)
                    render_results_modular(df_ergebnisse)
                except Exception as e:
                    st.error(f"Fehler beim Laden der Ergebnisse: {e}")
            else:
                st.info("Bitte wähle links ein Bundesland aus, um die KI-Waldbrandvorhersage zu starten.")
                
        # ------------------------------------------
        # HISTORIE (NUR EIGENE DATEN)
        # ------------------------------------------
        elif st.session_state["aktuelle_ansicht"] == "history":
            st.subheader("⏳ Deine vergangenen Vorhersagen")
            st.caption("Hier siehst du ausschließlich deine eigenen historischen Abfragen.")
            
            try:
                df_historie = db.get_ai_results(conn, username, bundesland=None)
                render_results_modular(df_historie)
            except Exception as e:
                st.error(f"Fehler beim Laden der Historie: {e}")
