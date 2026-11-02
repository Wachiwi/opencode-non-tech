---
name: Katalog-Index
description: Aktualisiert den lokalen RAG-Index über Datenblätter/Kataloge und führt strukturierte Suchen mit Verifikation im Original-PDF durch
---

## Wann

- Neue Datenblätter wurden in den Datenblätter-Ordner gelegt oder erwähnt.
- Eine Produkt-/Technik-Recherche braucht einen Ausgangspunkt („Welches Uplight hat 3000 lm und DALI-2?").

## Workflow

1. **Sync** (nur wenn Dateien neu hinzugekommen sind):
   ```sh
   npx mcp-local-rag sync "C:/Users/wachi/Datenblaetter"
   ```
   Erste Ausführung: lädt ~90 MB Embedding-Modell (1–2 min). Danach läuft es offline.
   Alternativ die MCP-Tools des Servers `rag` nutzen (sync, query).
2. **Suchen**:
   ```sh
   npx mcp-local-rag query "<suchbegriffe>" --db-path "C:/Users/wachi/Documents/Standardprojekt/.rag-index"
   ```
   Ergebnis ist JSON mit Datei + Chunk. Treffer nach Relevanz sortieren.
3. **Verifizieren** (Pflicht): das Original-PDF an der gefundenen Stelle öffnen und die Aussage dort bestätigen.
   RAG-Snippets werden **nie** ungeprüft als Quelle zitiert.
4. **Preise**: aus dem RAG-Index oder Datenblatt entnommene Preise sind ungültig. Preise nur aus der
   aktuellen Preisliste (`.xlsx`, siehe `kalkulation`-Skill).

## Regeln

- Nur **ein** Writer auf dem Index gleichzeitig (kein paralleler CLI- + MCP-Sync).
- Index liegt unter `C:/Users/wachi/Documents/Standardprojekt/.rag-index`, Cache unter `.rag-cache`.
- Excel (.xlsx) wird nicht indexiert – gewollt: Datenblätter (PDF) über RAG, Preislisten über Office-MCP.
- Nur ein Sync pro Session, wenn der Nutzer nicht explizit mehrfach verlangt.
