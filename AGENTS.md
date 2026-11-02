# Projekt-Regeln (Standardprojekt)

Diese Regeln gelten für alle Agenten in diesem Workspace.

## Sprache & Stil

- Antworte immer auf Deutsch, in klarer, einfacher Sprache (die Nutzungsperson ist nicht technisch).
- Keine Fach-Chats: Erkläre Fachbegriffe kurz, wenn sie auftauchen.
- Fasse Ergebnisse am Ende immer als kurze Zusammenfassung zusammen ("Was wurde gemacht / Was fehlt noch").

## Ordnerstruktur

Projekte liegen unter `Kunden/<Kunde>/<Projekt>/` mit dieser festen Struktur:

```text
Kunden/<Kunde>/<Projekt>/
├── 10_Angebote/        # Angebotstexte, Auskünfte
├── 20_Kalkulation/     # Preisschätzungen, Kalkulations-Tabellen, annahmen.md
├── 30_Datenblaetter/   # Projektspezifische Datenblätter (PDF)
├── 40_Dokumentation/   # protokoll.md, Entscheidungen, Fotos-Beschreibungen
└── 50_Vertraege/       # Verträge, Auftragsbestätigungen
```

- Pro Kunde gibt es zusätzlich `Kunden/<Kunde>/kunde.md` mit Stammdaten (Adresse, Ansprechpartner, Rahmenbedingungen).
- Dateinamen ohne Leerzeichen, mit Datum-Präfix `YYYY-MM-DD_` wenn zeitlich relevant.

## Harte Regeln (nicht verhandelbar)

1. **Preise kommen ausschließlich aus der aktuellen Preisliste** (`.xlsx` via Office-MCP oder vom Nutzer bereitgestellt). Niemals aus dem RAG-Index, aus dem Memory oder aus geschätzten Web-Preisen kalkulieren.
2. **Liegt keine Preisliste vor** → nachfragen oder deutlich als "Preisschätzung ohne gesicherte Preisbasis" markieren (in der Datei und in der Antwort).
3. **Datenblatt-Aussagen immer verifizieren**: RAG-Treffer sind Hinweise, nicht Quellen. Vor dem Zitieren von technischen Werten die Original-PDF-Seite lesen.
4. **Keine Dateien außerhalb des Workspaces löschen oder überschreiben.**
5. Bei mehr als einer sinnvollen Lösungsmöglichkeit: Optionen vorstellen und den Nutzer entscheiden lassen, bevor groß angelegt wird.

## Memory

- Das opencode-mem-Plugin speichert automatisch wichtige Erinnerungen (Entscheidungen, Präferenzen, Kundenkontext).
- Vor der Arbeit an einem bekannten Projekt: die Memory-Suche nutzen, um bereits bekannte Fakten (z. B. "Kunde X bevorzugt Hersteller Y") nicht zu widersprechen.
- Wichtige neue Entscheidungen sollten im Memory landen und zusätzlich in `40_Dokumentation/protokoll.md` dokumentiert werden.

## Wissens-Ebenen (niemals mischen)

| Ebene | Was | Quelle |
|---|---|---|
| 1 | RAG-Index | findet das richtige Datenblatt + Seite |
| 2 | Original-Dokument | verifiziert Specs und Artikeldaten |
| 3 | Preisliste | einzige Preis-Quelle |
