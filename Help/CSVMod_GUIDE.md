# CSVMod CSV Creation Guide

This guide documents how to create and edit CSV attack scripts for this repo, including CSVMod additions.

**Overview**
CSV scripts live in `CSV/Attack/*.csv`.
The bot loads all `.csv` files in that folder and lists them as scripted attacks.
Lines starting with `NOTE` are informational and ignored by the parser.
Add a `NOTE |CSV_VERSION|<version>` line to help the CSV Settings UI detect the script version.

**Quickstart**
A minimal CSV needs at least one `TRAIN`, one `SIDE`, one `MAKE`, and one `DROP` block.
Keep at least 8 columns per command line by using trailing `|` placeholders.

```csv
NOTE  |Author: YourName
NOTE  |CSV_VERSION|2.6
NOTE  |Attack Name: Example

      |_TROOPNAME_|__FLEXIBLE_|____TH06___|____TH07___|____TH08___|____TH09___|____TH10___|____TH11___|____TH12___|____TH13___|____TH14___|____TH15___|____TH16___|____TH17___|____TH18___|
TRAIN |Barb      |0          |0          |0          |0          |0          |0          |10         |10         |10         |10         |10         |10         |10         |10         |
TRAIN |RSpell    |0          |0          |0          |0          |0          |0          |1          |1          |1          |1          |1          |1          |1          |1          |

      |EXTR. GOLD |EXTR.ELIXIR|EXTR. DARK |DEPO. GOLD |DEPO.ELIXIR|DEPO. DARK |TOWNHALL   |FORCED SIDE|
SIDE  |0          |0          |0          |0          |0          |0          |8          |           |

      |VECTOR_____|SIDE_______|DROP_POINTS|ADDTILES___|VERSUS_____|RANDOMX_PX_|RANDOMY_PX_|BUILDING___|
MAKE  |A          |FRONT-LEFT |5          |0          |EXT-INT    |0          |0          |           |

      |VECTOR_____|INDEX______|QTY_X_VECT_|TROOPNAME__|DELAY_DROP_|DELAYCHANGE|SLEEPAFTER_|
DROP  |A          |1-5        |10         |Barb       |40-60      |100-140    |200-300    |
```

**Global Settings (Attack CSV Settings UI)**
These options are set in the Attack CSV Settings window and affect how CSV runs. They are not CSV commands.

Header actions:
- `Reload CSV` reloads the file and discards unsaved edits.
- `Validate CSV` runs quick validation for `MAKE`, `SIDE`, `WAIT` values.
- `Debug Locate` runs a locate/building debug pass on the current base.
- `Test Live` runs a live test attack using the selected CSV script.
- `Test Dry` runs a dry parse + precalc pass with no live actions.
- `Save and apply to GUI` writes changes and applies script settings to GUI elements.

Side Weights tab:
- `SIDE` weights for resource buildings (mine, elixir, drill, storages, town hall).
- `Forced side` selector when you want to override weight selection.
- Presets: `Zero`, `Equal`.

SIDEB Weights tab:
- Defense weights for the SIDEB calculation.
- Presets: `Zero`, `Equal`.

Vectors tab:
- Edit the selected `MAKE` vector: side, points, offset tiles, targeted building, versus order, random X/Y.

Drop tab:
- Edit `DROP` range values for the selected vector.
- Toggle `REMAIN` helper lines, and include heroes or spells in REMAIN.

Wait tab:
- Edit `WAIT` min/max and break conditions (TH, SIEGE, 50%, AQ/BK/GW/RC, AQ+BK).

Automation tab:
- Apply script settings back into GUI elements.

PRIO & Precalc tab:
- Precache mode: `Conservative` or `Aggressive`.
- Precalc status and `Rebuild Precalc`.
- RECALC overrides: side override and vector target filter.

Diagnostics tab:
- CSV diagnostics and refresh.

Debug tab:
- Debug flags: Log, Click, RedArea, OCR, AttackCSV, Make IMG CSV, Attack timing, Rescan logging.

**Settings Section (Applied via "Save and apply to GUI")**
These lines are read by the settings parser and can populate GUI settings automatically.

`TRAIN` rows:
- Column 2 is troop name.
- Column 3 is `FLEXIBLE` (only used for troops). If set to a positive value, the bot can adjust this troop count to match camp space.
- TH columns go from TH06 to TH18. The headers are for humans; the parser uses column position.

Hero ability settings:
- Use `TRAIN |King|...` or other hero names in the `TRAIN` section.
- Format is `MSS` where `M` is mode and `SS` is seconds.
- Mode meanings: `1` = Auto activate (red zone), `2` = Time after, `3` = Check both.
- Examples: `2` means mode 2 with 0 seconds, `215` means mode 2 with 15 seconds.

Other settings rows:
- `REDLN` selects redline routine preset.
- `DRPLN` selects dropline edge preset.
- `CCREQ` sets the clan castle request string.
- `BOOST` is recognized by the settings parser but may not trigger any action in this build.

Example settings block:

```csv
      |_TROOPNAME_|__FLEXIBLE_|____TH06___|____TH07___|____TH08___|____TH09___|____TH10___|____TH11___|____TH12___|____TH13___|____TH14___|____TH15___|____TH16___|____TH17___|____TH18___|
TRAIN |SArch     |0          |0          |0          |0          |0          |0          |0          |0          |0          |0          |0          |0          |10         |10         |
TRAIN |RSpell    |0          |0          |0          |0          |0          |0          |1          |1          |1          |1          |1          |1          |1          |1          |

      |_TROOPNAME_|___________|____TH06___|____TH07___|____TH08___|____TH09___|____TH10___|____TH11___|____TH12___|____TH13___|____TH14___|____TH15___|____TH16___|____TH17___|____TH18___|
TRAIN |King      |0          |0          |0          |0          |0          |0          |1          |1          |1          |1          |1          |1          |1          |1          |
TRAIN |Queen     |0          |0          |0          |0          |0          |0          |1          |1          |1          |1          |1          |1          |1          |1          |
TRAIN |Warden    |0          |0          |0          |0          |0          |0          |2          |2          |2          |2          |2          |2          |2          |2          |
TRAIN |Champion  |0          |0          |0          |0          |0          |0          |0          |0          |1          |1          |1          |1          |1          |1          |

      |___________|___________|____TH06___|____TH07___|____TH08___|____TH09___|____TH10___|____TH11___|____TH12___|____TH13___|____TH14___|____TH15___|____TH16___|____TH17___|____TH18___|
REDLN |0          |0          |0          |0          |0          |0          |0          |4          |4          |4          |4          |4          |1          |4          |4          |
DRPLN |0          |0          |0          |0          |0          |0          |0          |4          |4          |4          |4          |4          |1          |4          |4          |
CCREQ |           |           |           |           |           |           |           |Ball Rage  |Ball Rage  |Ball Rage  |Ball Rage  |Ball Rage  |Ball Rage  |Ball Rage  |Ball Rage  |
```

**Side Selection (`SIDE`)**
`SIDE` sets weights for resources and optional forced side selection.

Valid forced side values:
- `TOP-LEFT`, `TOP-RIGHT`, `BOTTOM-LEFT`, `BOTTOM-RIGHT`, `TOP-RAND`.

Example:

```csv
      |EXTR. GOLD |EXTR.ELIXIR|EXTR. DARK |DEPO. GOLD |DEPO.ELIXIR|DEPO. DARK |TOWNHALL   |FORCED SIDE|
SIDE  |5          |0          |0          |0          |0          |3          |0          |           |
```

**Defense Side (`SIDEB`)**
`SIDEB` weights pick a side using defenses. Column order is fixed.

Order (14 columns):
- `EAGLE`, `INFERNO`, `XBOW`, `WIZTOWER` (also covers Super Wiz), `MORTAR`, `AIRDEFENSE`, `SCATTER`, `SWEEPER`, `MONOLITH`, `FIRESPITTER`, `MULTIARCHER`, `MULTIGEAR`, `RICOCHETCA`, `REVENGETW`.

Example:

```csv
      |EAGLE      |INFERNO    |XBOW       |WIZTOWER   |MORTAR     |AIRDEFENSE |SCATTER    |SWEEPER    |MONOLITH   |FIRESPITTER|MULTIARCHER|MULTIGEAR  |RICOCHETCA |REVENGETW  |
SIDEB |5          |0          |0          |0          |0          |0          |0          |0          |0          |0          |0          |0          |0          |0          |
```

**PRIOCAP**
`PRIOCAP` caps the number of PRIO targets per side (top-left, top-right, bottom-left, bottom-right).

```csv
      |TOP-LEFT   |TOP-RIGHT  |BOTTOM-LEFT|BOTTOM-RIGHT|
PRIOCAP|3          |3          |2          |2           |
```

**MAKE**
`MAKE` defines drop vectors from a side. Vectors are letters `A` to `Z`. If a vector is defined more than once, the last one wins.

Valid sides:
- `FRONT-LEFT`, `FRONT-RIGHT`, `RIGHT-FRONT`, `RIGHT-BACK`, `LEFT-FRONT`, `LEFT-BACK`, `BACK-LEFT`, `BACK-RIGHT`, `RANDOM`.

Valid versus values:
- `EXT-INT`, `INT-EXT`, `IGNORE`.

Building target list for `value8`:
- `PRIO`, `TOWNHALL`, `EAGLE`, `INFERNO`, `XBOW`, `WIZTOWER`, `SUPERWIZTW`, `MORTAR`, `AIRDEFENSE`, `SWEEPER`, `MONOLITH`, `FIRESPITTER`, `MULTIARCHER`, `MULTIGEAR`, `RICOCHETCA`, `SCATTER`, `REVENGETW`, `EX-WALL`, `IN-WALL`.

Targeted MAKE notes:
- Use `value8` to target a building. `PRIO` uses the PRIO plan.
- Targeted vectors support 1 or 5 drop points.
- If a target is missing, the bot falls back to redline unless PRIOSTRICT is enabled.
- Random X/Y are ignored for targeted vectors.

Examples:

```csv
      |VECTOR_____|SIDE_______|DROP_POINTS|ADDTILES___|VERSUS_____|RANDOMX_PX_|RANDOMY_PX_|BUILDING___|
MAKE  |A          |FRONT-LEFT |10         |0          |EXT-INT    |5          |5          |           |
MAKE  |B          |FRONT-RIGHT|1          |1          |IGNORE     |0          |0          |INFERNO    |
MAKE  |C          |LEFT-FRONT |1          |1          |IGNORE     |0          |0          |PRIO       |
```

**DROP**
`DROP` deploys troops on a vector.

Fields:
- `VECTOR` can be a single letter or a list `A-B-C`.
- `INDEX` can be a single number, a range `1-5`, or a comma list `1,3,5`.
- `QTY_X_VECT` is total quantity (or range) for the indexes given.
- `TROOPNAME` is a troop short name. Use `REMAIN` to drop remaining troops.
- `DELAY_DROP`, `DELAYCHANGE`, `SLEEPAFTER` accept a single value or a range.

REMAIN flags:
- `REMAIN` drops remaining troops only.
- `REMAIN+HERO` includes heroes that are not yet deployed.
- `REMAIN+SPELL` includes spells.
- `REMAIN+ALL` includes both heroes and spells.

Examples:

```csv
      |VECTOR_____|INDEX______|QTY_X_VECT_|TROOPNAME__|DELAY_DROP_|DELAYCHANGE|SLEEPAFTER_|
DROP  |A          |1-5        |10         |Witc       |50-70      |27-50      |100-120    |
DROP  |A-B        |1-7        |10         |REMAIN+ALL |50-70      |30-50      |100-120    |
```

**WAIT**
`WAIT` pauses before the next line. Use milliseconds (1 second = 1000 ms).

Conditions (value2, comma separated):
- `TH`, `SIEGE`, `TH+SIEGE`, `50%`, `AQ`, `BK`, `GW`, `RC`, `AQ+BK`, `RESCAN`.

Example:

```csv
WAIT  |1000-3000  |TH,SIEGE   |
```

**RECALC**
`RECALC` rebuilds PRIO/targeted vectors during the attack.

Format:
- `RECALC | <budget_ms> | FORCE`.

Example:

```csv
RECALC|9000       |FORCE      |
```

**Compatibility Notes**
Include `NOTE |CSV_VERSION|<version>` to surface version in the CSV Settings UI.
Align with sample scripts in `CSV/Attack/` for column width and ordering.

