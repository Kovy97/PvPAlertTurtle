PvPAlertTurtle

Prevent accidental PvP flags.
PvPAlertTurtle shows a clear on-screen warning when your current target (player or NPC) is PvP-flagged and belongs to the opposing faction. Ideal for Hardcore play where a stray hit on a flagged guard or civilian can end a run.

Features

Opposing-faction PvP check: Alerts only if the target is PvP-flagged and from the other faction.

Players & NPCs: Works for both; optional fallback for NPCs with no faction info.

Vanilla-safe UI: ASCII-only messages, compatible with 1.12 fonts.

Lightweight: No libraries or dependencies.


Install

Extract the ZIP to:

World of Warcraft\Interface\AddOns\


Verify the final path is:

...\AddOns\PvPAlertTurtle\PvPAlertTurtle.toc


Folder name must match the .toc filename.

Launch the game (or /reload) and enable PvPAlertTurtle in the AddOns list.

How it works

The addon listens for target/faction changes and alerts when both are true:

Target is PvP-flagged (UnitIsPVP or FFA).

Target’s faction is opposing yours (UnitFactionGroup).

If an NPC returns no faction (nil), no alert is shown by default. You can toggle a fallback that uses hostility instead.
