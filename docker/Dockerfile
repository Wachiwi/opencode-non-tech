# OpenCode-Server im Container (Skeleton)
# Basis: Node-Image, weil die MCP-Server (mcp-local-rag, kordoc, playwright) über npx laufen.
# opencode selbst wird als npm-Paket installiert.

FROM node:24-bookworm-slim

# OpenCode-CLI installieren
RUN npm install -g opencode-ai

# Werkzeuge für npx-basierte MCP-Server
RUN npm install -g mcp-local-rag

# Playwright-Browser für Katalog-Recherche (headless Chromium)
RUN npm install -g playwright && npx playwright install --with-deps chromium

# Arbeitsverzeichnis im Container
WORKDIR /workspace

# Server im Vordergrund starten (Port über docker-compose gesetzt)
CMD ["opencode", "serve", "--hostname", "0.0.0.0", "--port", "4096"]
