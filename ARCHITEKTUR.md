# Standardprojekt – Architektur-Skeleton

Stand: 2026-10-27

## Bausteine

| Baustein | Zweck | Status |
|---|---|---|
| **opencode-mem** | Erinnerungen aus Gesprächen: Entscheidungen, Präferenzen, Projekt-Kontext | geplant |
| **Office-MCP** | Direkter Lese-Zugriff auf aktuelle Preislisten (`.xlsx`) | geplant |
| **Playwright / Fetch** | Abruf von Hersteller-Katalogen online | geplant |
| **mcp-local-rag** | Lokaler RAG-Index über Datenblätter/Kataloge (PDF, DOCX, MD, TXT). Hybrid-Suche (semantisch + Keyword), Zitate mit Seitenzahl. Kein API-Key, kein Docker, offline nach Modell-Download (~90 MB) | **neu aufgenommen** |

## Drei getrennte Wissens-Ebenen (nicht vermischen!)

1. **RAG** → findet das richtige Dokument + Seite
2. **Agent liest Original-PDF** → verifiziert Specs und Artikeldaten
3. **Preise immer aus der aktuellen Preisliste** (`.xlsx` via Office-MCP) – **niemals** aus RAG-Index oder Memory, weil sich Preise laufend ändern. Harte Regel im `kalkulation`-Skill.

## mcp-local-rag – Konfiguration

```jsonc
// opencode config
{
  "mcp": {
    "servers": {
      "rag": {
        "type": "local",
        "command": ["npx", "-y", "mcp-local-rag"],
        "environment": {
          "BASE_DIR": "~/Datenblaetter",
          "DB_PATH": "~/Documents/Standardprojekt/.rag-index",
          "CACHE_DIR": "~/Documents/Standardprojekt/.rag-cache"
        }
      }
    }
  }
}
```

### Hinweise für den Deployment-Check

- **Excel (.xlsx) wird nicht indexiert** → Datenblätter (PDF) über RAG, Preislisten über Office-MCP. Gewollt.
- Standard-Embedding-Modell ist englisch-lastig → beim Deployment prüfen, ob ein multilinguales Modell per `--model-name`/`--cache-dir` gesetzt werden kann (deutsche Datenblätter).
- Erwartete Korpusgröße: **< 100 Dateien**. RAG lohnt sich trotzdem, weil der Nutzer i. d. R. nicht weiß, in welchem PDF welcher Wert steht. Unter ~50 rein überschaubaren Dateien wäre glob/grep auch genug.
- Nur **ein** Writer gleichzeitig auf `DB_PATH` (kein paralleler CLI-Sync + MCP-Sync).

## Skills

### `katalog-index`

- Zweck: Index aktuell halten, Suchen strukturieren.
- Ablauf:
  1. Wenn Nutzer neue Datenblätter erwähnt hat → `npx mcp-local-rag sync ~/Datenblaetter/` (im Hintergrund, 1–2 min beim ersten Lauf).
  2. Suche: `npx mcp-local-rag query "<begriffe>"` → Ergebnis mit Datei + Chunk-Index.
  3. Ergebnis **verifizieren**: Original-PDF an der gefundenen Seite lesen, nicht nur das RAG-Snippet zitieren.
- Ergebnisform des CLI-Query: JSON auf stdout, Feldkontrakt in `docs/schema/query-output.schema.json` des Repos.

### `kalkulation` (geplant)

- Harte Regel: Preise ausschließlich aus aktueller Preisliste (Office-MCP), nie aus RAG/Memory.
- Wenn Preisliste nicht vorliegt → nachfragen statt schätzen.

## Dependency-Budget

Eine einzige neue Abhängigkeit: `mcp-local-rag` (pur via npx, kein eigener Dienst, kein Docker). Alles andere läuft über vorhandene Bausteine.

## Offene Fragen

- [ ] Wo liegt der Datenblätter-Ordner konkret? (`BASE_DIR` oben ist Platzhalter: `~/Datenblaetter`)
- [ ] Multilinguales Embedding-Modell testen (deutsche PDFs)
- [ ] Wer triggert Sync automatisch (Skill-Aufruf vs. manuell)?
