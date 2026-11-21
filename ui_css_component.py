import pandas as pd
import streamlit as st
import streamlit.components.v1 as components


def inject_custom_scrollbar_css():
    """Lädt das CSS für den blauen Fortschrittsbalken in der Haupt-App."""
    st.markdown(
        """
        <style>
        div[data-testid="stProgress"] > div > div > div > div {
            background-color: #1f77b4 !important;
        }
        </style>
        """,
        unsafe_allow_html=True,
    )


def _farbe_wahrscheinlichkeit(val):
    """Färbt die Prozentwerte nach Risikostufe ein."""
    try:
        zahl = float(str(val).replace("%", "").strip())
        if zahl >= 70:
            return "color: #ff4b4b; font-weight: bold;"  # Rot
        elif zahl >= 50:
            return "color: #ffa500; font-weight: bold;"  # Orange
        else:
            return "color: #21c354; font-weight: bold;"  # Grün
    except ValueError:
        return ""


def render_styled_table(df_display: pd.DataFrame):
    """Zeigt das DataFrame mit klickbaren Sortier-Chevrons, Farben und Firefox-Scrollbars an."""
    inject_custom_scrollbar_css()

    styled_df = df_display.style.hide(axis="index")
    if "KI-Wahrscheinlichkeit" in df_display.columns:
        styled_df = styled_df.map(
            _farbe_wahrscheinlichkeit, subset=["KI-Wahrscheinlichkeit"]
        )

    html_table = styled_df.to_html()

    # Komplettes HTML-Dokument für das Iframe inkl. deinem CSS und Sortier-JS
    full_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <style>
        body {{
            margin: 0;
            padding: 0;
            background-color: transparent;
            font-family: "Source Sans Pro", sans-serif;
            font-size: 14px;
            color: #fafafa;
        }}

        /* Äußerer Rahmen um die gesamte Box */
        div.table-outer-wrapper {{
            border: 1px solid #444;
            border-radius: 6px;
            overflow: hidden;
            width: 100%;
            display: block;
            box-sizing: border-box;
        }}

        /* Innerer Scroll-Bereich (inkl. Firefox-Fix) */
        div.custom-scroll-box {{
            max-height: 450px;
            width: 100%;
            display: block;
            overflow-x: scroll !important;
            overflow-y: auto !important;
            box-sizing: border-box;
            scrollbar-width: auto !important;
            scrollbar-color: #666666 #2b2d38 !important;
        }}

        div.custom-scroll-box::-webkit-scrollbar {{
            width: 24px !important;
            height: 24px !important;
        }}
        div.custom-scroll-box::-webkit-scrollbar-track {{
            background: #2b2d38 !important;
        }}
        div.custom-scroll-box::-webkit-scrollbar-thumb {{
            background-color: #666666 !important;
            border-radius: 6px !important;
            border: 3px solid #2b2d38 !important;
        }}

        /* Puffer gegen Verdecken der letzten Zeile */
        div.custom-scroll-box::after {{
            content: "";
            display: block;
            height: 30px;
            width: 100%;
        }}

        div.custom-scroll-box table {{
            width: max-content !important;
            min-width: 100% !important;
            border-collapse: collapse !important;
            white-space: nowrap !important;
            background-color: #0e1117;
        }}

        div.custom-scroll-box th, div.custom-scroll-box td {{
            padding: 10px 14px !important;
            text-align: left !important;
            border-bottom: 1px solid #444 !important;
        }}

        /* Fixierte, klickbare Kopfzeile */
        div.custom-scroll-box th {{
            position: sticky !important;
            top: 0 !important;
            background-color: #262730 !important;
            color: #ffffff !important;
            font-weight: bold !important;
            z-index: 2 !important;
            cursor: pointer;
            user-select: none;
            transition: background-color 0.15s ease;
        }}

        div.custom-scroll-box th:hover {{
            background-color: #363846 !important;
        }}

        /* Chevron-Styling */
        .sort-chevron {{
            display: inline-block;
            margin-left: 6px;
            font-size: 11px;
            color: #888;
        }}
        th.sort-asc .sort-chevron,
        th.sort-desc .sort-chevron {{
            color: #ff4b4b;
        }}

        /* Fixierte erste Spalte */
        div.custom-scroll-box td:first-child,
        div.custom-scroll-box th:first-child {{
            position: sticky !important;
            left: 0 !important;
            background-color: #1e1f26 !important;
            z-index: 1 !important;
            border-right: 1px solid #444 !important;
        }}
        div.custom-scroll-box th:first-child {{
            background-color: #262730 !important;
            z-index: 3 !important;
        }}
        div.custom-scroll-box th:first-child:hover {{
            background-color: #363846 !important;
        }}
    </style>
    </head>
    <body>
        <div class="table-outer-wrapper">
            <div class="custom-scroll-box">
                {html_table}
            </div>
        </div>

        <script>
           document.addEventListener("DOMContentLoaded", function() {{
            const table = document.querySelector("table");
            if (!table) return;

            const headers = table.querySelectorAll("thead th");
            const tbody = table.querySelector("tbody");
            let currentSortCol = -1;
            let currentSortDir = "asc";

            // Chevrons & Standard-Tooltips zu allen Spaltenüberschriften hinzufügen
            headers.forEach((th, index) => {{
                const span = document.createElement("span");
                span.className = "sort-chevron";
                span.textContent = "⇅";
                th.appendChild(span);

                // Standard-Tooltip vor dem ersten Klick
                th.title = "Nicht sortiert – Klicken zum aufsteigenden Sortieren";

                th.addEventListener("click", () => {{
                    // Richtung umschalten
                    if (currentSortCol === index) {{
                        currentSortDir = currentSortDir === "asc" ? "desc" : "asc";
                    }} else {{
                        currentSortCol = index;
                        currentSortDir = "asc";
                    }}

                    // Alle Chevrons und Tooltips zurücksetzen
                    headers.forEach(h => {{
                        h.classList.remove("sort-asc", "sort-desc");
                        h.querySelector(".sort-chevron").textContent = "⇅";
                        h.title = "Nicht sortiert – Klicken zum aufsteigenden Sortieren";
                    }});

                    // Aktiven Chevron & passenden Tooltip setzen
                    const chevron = th.querySelector(".sort-chevron");
                    if (currentSortDir === "asc") {{
                        th.classList.add("sort-asc");
                        chevron.textContent = "▲";
                        th.title = "Sortierung: Aufsteigend (Klicken für Absteigend)";
                    }} else {{
                        th.classList.add("sort-desc");
                        chevron.textContent = "▼";
                        th.title = "Sortierung: Absteigend (Klicken für Aufsteigend)";
                    }}

                    // Zeilen sortieren
                    const rows = Array.from(tbody.querySelectorAll("tr"));
                    rows.sort((rowA, rowB) => {{
                        let valA = rowA.children[index].innerText.trim();
                        let valB = rowB.children[index].innerText.trim();

                        const numA = parseFloat(valA.replace("%", "").replace(",", "."));
                        const numB = parseFloat(valB.replace("%", "").replace(",", "."));

                        const isPureNumber = /^[+-]?\\d+([.,]\\d+)?\\s*%?$/.test(valA) && /^[+-]?\\d+([.,]\\d+)?\\s*%?$/.test(valB);

                        let comparison = 0;
                        if (isPureNumber && !isNaN(numA) && !isNaN(numB)) {{
                            comparison = numA - numB;
                        }} else {{
                            comparison = valA.localeCompare(valB, "de", {{ sensitivity: "base" }});
                        }}

                        return currentSortDir === "asc" ? comparison : -comparison;
                    }});

                    // Sortierte Zeilen wieder einhängen
                    rows.forEach(row => tbody.appendChild(row));
                }});
            }});
        }});
        </script>        
    </body>
    </html>
    """

    # Höhe dynamisch an Zeilenanzahl anpassen (max. 475px für Scroll-Box + Rahmen)
    geschaetzte_hoehe = min(480, max(140, (len(df_display) + 1) * 44 + 45))
    components.html(full_html, height=geschaetzte_hoehe, scrolling=False)
