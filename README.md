# Standardprojekt – OpenCode-Setup

Konfiguration für OpenCode (nicht-technische Nutzung, Elektro-/Gebäudetechnik-Umfeld).

## Was ist hier konfiguriert?

| Datei/Ordner | Zweck |
|---|---|
| `opencode.jsonc` | Hauptkonfiguration: Modell, MCP-Server, Berechtigungen |
| `AGENTS.md` | Projektregeln für alle Agenten (Sprache, Ordnerstruktur, harte Regeln) |
| `.opencode/agents/` | 4 Agenten: `planer` (Hauptagent), `rechner`, `dokumentar`, `katalog` |
| `.opencode/skills/` | 5 Skills: `katalog-index`, `datenblatt-beschaffen`, `kalkulation`, `neues-projekt`, `protokoll` |
| `.opencode/commands/` | Befehle: `/neues-projekt`, `/kalkulation`, `/sync-katalog`, `/protokoll`, `/datenblatt` |
| `Kunden/` | Projektordner nach festem Schema (wird bei Bedarf angelegt) |

## Einmalig einrichten

1. **OpenRouter-API-Key** als Umgebungsvariable `OPENROUTER_API_KEY` setzen – niemals direkt in die Config schreiben.
2. **Datenblätter-Ordner** anlegen bzw. Pfad in `opencode.jsonc` unter `mcp → servers → rag → environment → BASE_DIR` auf den echten Ordner zeigen lassen (aktuell: `C:/Users/wachi/Datenblaetter`).
3. **Ersten Index-Lauf** starten (in OpenCode: `/sync-katalog`) – lädt einmalig ~90 MB Embedding-Modell, danach läuft alles offline.
4. **Office-MCP** (kordoc) ist deaktiviert (`"disabled": true`). Vor der ersten Kalkulation das Startkommando prüfen (`npx kordoc --help`) und auf `false` setzen.
5. Optional: **opencode-mem** speichert Erinnerungen lokal und bietet eine Web-UI auf `127.0.0.1:4747`.

## Modell-Zuordnung

| Agent | Modell | Warum |
|---|---|---|
| planer | `openrouter/~z-ai/glm-flash-latest` | günstig, schnell, für Dialog und Planung |
| rechner | `openrouter/anthropic/claude-opus-5.5` | präzises Rechnen/Kalkulieren |
| dokumentar | `openrouter/deepseek/deepseek-v4.1-flash-1017` | schnelles, sauberes Schreiben |
| katalog | `openrouter/~z-ai/glm-flash-latest` | schnelle Recherche |

## Typischer Ablauf

1. `/neues-projekt <Kunde> <Projekt>` → legt Ordnerstruktur an.
2. Datenblätter in `30_Datenblaetter/` (oder den zentralen Datenblätter-Ordner) legen, dann `/sync-katalog`.
   Alternativ: `/datenblatt <Hersteller> <Produkt>` → sucht und lädt das Datenblatt automatisch aus dem Web,
   legt es ab, verifiziert es und synchronisiert den Index. So wächst der Katalog Stück für Stück mit.
3. `/kalkulation <Beschreibung>` → rechner-Subagent kalkuliert (Preise nur aus der aktuellen Preisliste).
4. `/protokoll <Was wurde gemacht>` → dokumentiert den Arbeitsschritt.

## Docker-Deployment (optional)

Das Setup lässt sich als Container kapseln: Ein OpenCode-Server läuft in Docker, OpenCode Desktop
verbindet sich mit ihm – nur gemountete Ordner sind für den Server sichtbar.

### Architektur

```text
Windows-Rechner                          Docker-Container
┌─────────────────────┐                 ┌─────────────────────────────────┐
│ OpenCode Desktop    │  Passwort-Auth  │ opencode serve (Port 4096)      │
│ verbindet über      │ ──────────────► │ ├─ Agenten, Skills, Plugins     │
│ http://localhost:   │                 │ ├─ mcp-local-rag (RAG-Index)    │
│ 4096                │                 │ ├─ Playwright (Chromium headless)│
└─────────────────────┘                 └────────────┬────────────────────┘
                                                     │ Bind-Mounts (nur diese!)
                                          ┌──────────┴──────────┐
                                          │ Kunden/  Datenblätter/│
                                          └───────────────────────┘
```

### Einrichtung

1. `cd docker && copy .env.example .env` → `.env` ausfüllen (API-Key + Server-Passwort).
2. `docker compose up -d --build` baut und startet den Server.
3. In **OpenCode Desktop** die Server-Adresse `http://localhost:4096` eintragen (Server-Adresse-Feld)
   und das Passwort aus `OPENCODE_PASSWORD` angeben.
4. Erster Sync: `/sync-katalog` (lädt einmalig ~90 MB Modell in den Container-Volume).

### Wichtig

- **Container-Pfade**: Die Container-Config `docker/opencode-config/opencode.jsonc` nutzt
  `/workspace/Datenblaetter` statt `C:/Users/wachi/Datenblaetter` – die zwei Configs müssen
  bei Änderungen synchron gehalten werden.
- **Kommandos im Container** ändern Files in den gemounteten Ordnern → sie erscheinen direkt auf
  dem Windows-Rechner.
- **Nur gemountete Ordner** sind sichtbar: Der Server kann NICHT auf beliebige Windows-Ordner zugreifen.
- `opencode-data` ist ein Docker-Volume: RAG-Index, Memory-DB und Session-Datenbank überleben
  Container-Rebuilds (der `--build`-Rebuild selbst ist dann auch schnell).
- Passwort-Auth: Verbindung nur mit `OPENCODE_PASSWORD` möglich; der Port ist nur lokal
  (`localhost:4096`) exponiert – nicht über das Netzwerk erreichbar.

## WSL + Autostart (optional, empfohlen)

Der Container läuft dann in einer WSL-Distribution mit systemd und startet automatisch bei jedem
Windows-Neustart. Windows erreicht den Server über `localhost:4096` (WSL2 localhost-Weiterleitung).

### Architektur

```text
Windows
├── OpenCode Desktop ──► http://localhost:4096 (WSL2 localhost-Forward)
└── WSL2 (Ubuntu, systemd)
    └── Docker CE
        └── opencode-Container (Port 4096)
```

### Einrichtung

1. WSL-Distribution installieren (z. B. `wsl --install -d Ubuntu-24.04`).
2. Projekt nach `~/Standardprojekt` in die WSL-Distribution kopieren (Bind-Mounts aus dem
   WSL-Dateisystem sind deutlich schneller als `/mnt/c/...`).
3. `cd ~/Standardprojekt/docker/wsl && sudo bash wsl-setup.sh` – richtet Docker CE, systemd und
   den Dienst ein. Beim ersten Lauf wird systemd aktiviert und der WSL-Neustart verlangt:
   danach `wsl-setup.sh` nochmal ausführen (Schritt 2).
4. Windows-Autostart: WSL soll beim Windows-Login starten, damit der Dienst auch läuft, wenn
   kein Terminal offen ist:
   - **Task Scheduler** (Task Scheduler → Neue Aufgabe → Bei Anmeldung):
     `wsl -d Ubuntu-24.04 --exec true`
   - Oder in einem Startordner-Skript: `wsl -d Ubuntu-24.04 --exec true`
5. Desktop-Verbindung: unverändert `http://localhost:4096` mit `OPENCODE_PASSWORD`.

### Wichtige Hinweise

- **Datei-Zugriff aus Windows**: Das Projekt liegt jetzt im WSL-Dateisystem – Windows greift über
  `\\wsl$\Ubuntu-24.04\home\<user>\Standardprojekt` darauf zu. In OpenCode Desktop diesen Pfad
  als Workspace öffnen.
- **Docker Desktop vs. Docker CE**: Falls bereits Docker Desktop mit WSL-Backend läuft, kann der
  native Docker in WSL (Schritt 2) weggelassen werden – dann aber die WSL-Integration in
  Docker Desktop für diese Distribution aktivieren. **Nicht** beides gleichzeitig in derselben
  Distribution.
- **Status prüfen**: In WSL `systemctl status opencode.service` oder unter Windows
  `curl -u opencode:<passwort> http://localhost:4096/api/info`.
- Der Service startet den Container automatisch; nach einem Rebuild (`docker compose up -d --build`)
  braucht der Dienst keinen Neustart.
