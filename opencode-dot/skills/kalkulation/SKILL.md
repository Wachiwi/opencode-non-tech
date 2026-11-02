---
name: Kalkulation
description: Erstellt Preisschätzungen und Kalkulationen – Preise nur aus der aktuellen Preisliste, mit dokumentierten Annahmen
---

## Wann

- Preisschätzung, Angebotskalkulation oder Materialzusammenstellung für ein Projekt.

## Harte Regeln (immer)

1. **Preise ausschließlich aus der aktuellen Preisliste** (`.xlsx` im Projektordner oder via Office-MCP `office`).
   RAG-Index, Memory und Web-Preise sind **keine** Preis-Quelle.
2. **Keine Preisliste vorliegend?** → nachfragen. Alternativ eine ausdrücklich als
   „Schätzung ohne gesicherte Preisbasis" markierte Grobschätzung liefern.
3. **Technische Werte** (Leistung, Lumen, Schutzart, Artikelnr.) nur aus dem Original-Datenblatt (PDF),
   nicht aus RAG-Snippets oder Memory.

## Ablauf

1. **Positionen klären**: Was, wie viele Stück, welche Hersteller/Vorgaben?
2. **Artikel finden**: katalog-index-Skill → RAG-Index → Original-PDF verifizieren.
3. **Preise ziehen**: Artikelnr. gegen die aktuelle Preisliste abgleichen (Office-MCP oder direkt lesen).
4. **Kalkulation schreiben** nach `Kunden/<Kunde>/<Projekt>/20_Kalkulation/`:
   - `YYYY-MM-DD_kalkulation.md` – Tabelle: Position | Artikel-Nr. | Bezeichnung | Stück | Einzelpreis | Summe
   - `annahmen.md` – alle Annahmen (Marge, Pauschalen, fehlende Preise, Personalkosten-Sätze)
5. **Zusammenfassung** an den Nutzer: Gesamtsumme, größte Kostenblöcke, Unsicherheiten, fehlende Daten.

## Delegation

Der primäre Agent delegiert den Schritt 2–3 an den **rechner**-Subagenten, der mit einem
starken Modell (Opus) rechnet. Der primäre Agent prüft das Ergebnis und übergibt es an den Nutzer.
