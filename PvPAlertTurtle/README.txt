PvPAlertTurtle (Vanilla 1.12) v1.7 — English
- Alerts only when your TARGET is PvP-flagged AND belongs to the opposing faction (Player or NPC).
- ASCII messages (Vanilla-safe).

Optional:
- "/pvpalertturtle fallback" -> If UnitFactionGroup(target) returns nil (some NPCs), use hostility (UnitIsEnemy) as fallback.

Install:
World of Warcraft\Interface\AddOns\PvPAlertTurtle\
  PvPAlertTurtle.toc
  PvPAlertTurtle.xml
  PvPAlertTurtle.lua

Commands:
- /pvpalertturtle sound     toggle sound
- /pvpalertturtle fallback  toggle fallback when faction is nil
(Alias: /pvpalert)
