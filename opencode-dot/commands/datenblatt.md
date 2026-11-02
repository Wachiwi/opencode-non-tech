---
description: Sucht und lädt ein Hersteller-Datenblatt aus dem Web, legt es ab und aktualisiert den Index
agent: planer
---

Beschaffe das Datenblatt für: $ARGUMENTS

Vorgehen (Skill „datenblatt-beschaffen"):
1. Zuerst lokal prüfen (RAG-Index + Datenblätter-Ordner) – nur beschaffen, was fehlt.
2. Web-Suche nach offizieller Hersteller-Quelle, Download in den Datenblätter-Ordner
   (oder `30_Datenblaetter/` des Projekts, wenn ein Projekt bekannt ist).
3. PDF verifizieren (richtiges Produkt, lesbar) und den Katalog-Index einmal am Ende synchronisieren.
4. Melden: Was wurde geladen, wohin abgelegt, ob es verifiziert ist.
