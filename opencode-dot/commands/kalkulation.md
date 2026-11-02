---
description: Startet eine Preisschätzung/Kalkulation
agent: planer
---

Erstelle eine Kalkulation für: $ARGUMENTS

Vorgehen:
1. Positionen und Stückzahlen mit dem Nutzer klären, wenn unklar.
2. Beziehe den rechner-Subagenten ein (Skill „kalkulation") – er prüft Datenblätter und zieht
   Preise ausschließlich aus der aktuellen Preisliste.
3. Leg das Ergebnis in `Kunden/<Kunde>/<Projekt>/20_Kalkulation/` ab
   (`YYYY-MM-DD_kalkulation.md` + `annahme.md`).
4. Gib am Ende eine verständliche Zusammenfassung: Summe, größte Posten, Unsicherheiten.
