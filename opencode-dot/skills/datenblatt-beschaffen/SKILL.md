---
name: Datenblatt-Beschaffen
description: Sucht Hersteller-Datenblätter im Web, lädt sie in den Datenblätter-Ordner, verifiziert sie und aktualisiert den RAG-Index
---

## Wann

- Ein gesuchtes Produkt/Datenblatt liegt noch nicht lokal (RAG-Index oder Datenblätter-Ordner).
- Der Nutzer bittet um Recherche nach einem bestimmten Artikel oder Produkttyp.

## Workflow

1. **Auftrag klären**: Hersteller, Produkt/Typ, ggf. Artikelnummer. Bei Unklarheit kurz nachfragen.
2. **Zuerst prüfen, ob es schon da ist**:
   - RAG-Index-Abfrage (Skill `katalog-index`, Schritt 2) bzw. `glob`/`grep` im Datenblätter-Ordner.
   - Nur wenn wirklich nicht vorhanden → weiter mit Schritt 3.
3. **Web-Suche**:
   - `websearch` nach `"<Hersteller> <Produkt> Datenblatt PDF"` bzw. `datasheet`.
   - `webfetch` auf die Hersteller-Produktseite; bei JS-lastigen Katalogseiten den Playwright-Browser nutzen.
   - Direkter PDF-Link bevorzugen (offizielle Hersteller-Domain, keine Dritt-Sammlungen).
4. **Herunterladen und ablegen**:
   - Zentraler Ordner (wie in `opencode.jsonc` → `BASE_DIR`) für allgemeine Datenblätter,
     `Kunden/<Kunde>/<Projekt>/30_Datenblaetter/` für projektspezifische.
   - Dateiname: `<hersteller>_<artikelnummer>_<bezeichnung>.pdf`, ohne Leerzeichen/Umlaute
     (z. B. `gira_202003_schalter-weiss.pdf`).
   - Existiert der Dateiname schon → nicht überschreiben, neues Datum-Präfix `YYYY-MM-DD_` ergänzen.
5. **Verifizieren (Pflicht)**: Die heruntergeladene PDF öffnen und prüfen:
   - Ist es wirklich das gesuchte Produkt/Modell?
   - Passt die Artikelnummer?
   - Ist die Datei lesbar (kein fehlerhafter/abgeschnittener Download)?
   - Nicht passende oder defekte Downloads löschen und Quelle wechseln.
6. **Index aktualisieren**: Skill `katalog-index` Schritt 1 (Sync) – **maximal einmal pro Session**,
   am Ende der Beschaffungs-Aktion, nicht nach jedem einzelnen PDF.
7. **Melden**: Kurzliste an den Nutzer: Was wurde heruntergeladen, wohin, was ist verifiziert, was noch offen.

## Regeln

- **Vorab-Check statt Doppel-Download**: erst lokal suchen, dann im Web.
- **Massen-Download nur mit Zustimmung**: Mehr als ~5 Dateien pro Aktion vorher ankündigen.
- Nur offizielle Hersteller-Quellen als Primärquelle; Drittseiten nur, wenn es keine offizielle gibt
  (dann im Protokoll vermerken, woher die Datei stammt).
- Technische Werte erst nach der Verifikation (Schritt 5) als Fakten zitieren – siehe AGENTS.md, harte Regel 3.
- Preise aus Web-Shops sind **keine** Preisbasis (harte Regel 1); der Preis kommt nur aus der Preisliste.
- Kein Sync pro Einzeldatei – einmal am Ende der Aktion reicht.
