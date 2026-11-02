---
name: Neues Projekt
description: Legt die feste Kunden-/Projektordner-Struktur mit Stammdaten an
---

## Wann

- Neuer Kunde oder neues Projekt für einen bestehenden Kunden.

## Ablauf

1. **Klären**: Kundenname, Projektname, kurze Projektbeschreibung, ggf. Rahmendaten (Termin, Budgetrahmen).
2. **Struktur anlegen**:
   ```text
   Kunden/<Kunde>/kunde.md                # Stammdaten (Adresse, Ansprechpartner, Notizen)
   Kunden/<Kunde>/<Projekt>/
   ├── 10_Angebote/
   ├── 20_Kalkulation/
   ├── 30_Datenblaetter/
   ├── 40_Dokumentation/
   │   └── protokoll.md                   # mit Erst-Eintrag anlegen
   └── 50_Vertraege/
   ```
3. **kunde.md** füllen, wenn Daten bekannt (sonst Platzhalter-Kommentare hinterlassen).
4. **protokoll.md** mit Erst-Eintrag `## YYYY-MM-DD – Projekt angelegt` anlegen.
5. Bestätigen mit dem Anlegen-Kurzpfad (z. B. `Kunden/Müller/Wohnhaus-Sanierung angelegt`).

## Regeln

- Ordnernamen: keine Leerzeichen, keine Umlaute (z. B. `Wohnhaus-Sanierung` statt `Wohnhaus Sanierung`).
- Bestehende Kundenordner nicht umbenennen oder zusammenlegen, ohne den Nutzer zu fragen.
- Existiert der Kunde schon → nur den Projektordner unterhalb anlegen.
