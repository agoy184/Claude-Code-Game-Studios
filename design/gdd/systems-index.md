# St Patrick's Luck — Systems Index

**Project**: St Patrick's Luck
**Genre**: Micro Roguelike
**Last Updated**: 2026-03-25
**Status**: Systems Enumerated; Design Order Established

---

## Executive Summary

St Patrick's Luck consists of **24 systems** organized across Foundation, Core, Feature, Presentation, and Polish layers.

- **MVP Systems**: 16 (core gameplay loop playable and complete)
- **Vertical Slice Systems**: 6 (polish and full roguelike feature set)
- **Alpha Systems**: 2 (nice-to-have UI and localization)
- **High-Risk Systems**: 3 (Luck System, Combat System, Enemy/Encounter System)

---

## Systems Enumeration

### Foundation Layer (Zero Dependencies)
| # | System | Priority | Description | Status |
|---|--------|----------|-------------|--------|
| 1 | Stats System | MVP | Player attributes and numeric tracking | Not Started |
| 2 | Items System | MVP | Loot database, equipment management | Not Started |
| 3 | Boons System | MVP | Power-ups and run modifiers | Not Started |
| 4 | Input System | MVP | Keyboard/controller input handling | Not Started |
| 5 | Audio System | MVP | Music, SFX, audio mixing | Not Started |
| 6 | Localization | Alpha | String management for translation | Not Started |

### Core Layer (Gameplay Engine)
| # | System | Priority | Description | Dependencies | Status |
|---|--------|----------|-------------|--------------|--------|
| 7 | Health System | MVP | Player health, damage tracking | — | Not Started |
| 8 | Luck System | MVP | **Central mechanic**; affects probabilities | — | Not Started |
| 9 | Curse System | MVP | Risk/consequence; curses modify rules | Luck System | Not Started |
| 10 | Damage/Combat Resolution | MVP | Combat math, hit/miss logic | Health System, Luck System | Not Started |

### Feature Layer (Gameplay Depth)
| # | System | Priority | Description | Dependencies | Status |
|---|--------|----------|-------------|--------------|--------|
| 11 | Combat System | MVP | Player combat interactions | Damage Resolution, Enemy System, Luck System | Not Started |
| 12 | Enemy/Encounter System | MVP | Enemy spawning, encounter design | Combat System, Loot Generation, Luck System | Not Started |
| 13 | Loot Generation | MVP | Item/boon drop logic and rates | Items System, Boons System, Luck System | Not Started |
| 14 | Death/Run End Conditions | MVP | How runs conclude (victory/death) | Health System, Permanent Progression | Not Started |
| 15 | Permanent Progression | MVP | Meta-progression unlocks and upgrades | Save/Load System | Not Started |
| 16 | Procedural Generation | Vertical Slice | Random level/encounter generation | Enemy/Encounter System, Loot Generation | Not Started |

### Presentation Layer (User Interface)
| # | System | Priority | Description | Dependencies | Status |
|---|--------|----------|-------------|--------------|--------|
| 17 | Run HUD | MVP | Real-time stat/health/luck display | Stats, Health, Luck, Curse, Items (display) | Not Started |
| 18 | Main Menu | MVP | Start run, view upgrades, exit	| Save/Load, Permanent Progression | Not Started |
| 19 | Boon Selection UI | Vertical Slice | Mid-run boon choice/upgrade screen | Boons System | Not Started |
| 20 | Inventory/Equipment UI | Vertical Slice | Manage items and equipment | Items System | Not Started |
| 21 | Run Summary Screen | Vertical Slice | End-of-run stats and unlocks | All gameplay systems (display) | Not Started |
| 22 | Settings Menu | Alpha | Audio, input, difficulty options | — | Not Started |

### Polish & Feedback Layer
| # | System | Priority | Description | Dependencies | Status |
|---|--------|----------|-------------|--------------|--------|
| 23 | Visual Effects System | Vertical Slice | Particle effects, green chaos glow | — | Not Started |
| 24 | Feedback System | Vertical Slice | Screenshake, damage numbers, hit impact | Audio System, Visual Effects | Not Started |

### Foundation (Utility)
| # | System | Priority | Description | Status |
|---|--------|----------|-------------|--------|
| — | Save/Load System | MVP | Serialization for runs + progression | Not Started |

---

## Recommended Design Order

**This order respects dependencies and priority tiers:**

1. **Stats System** (MVP, Foundation) — Data structure for player attributes
2. **Items System** (MVP, Foundation) — Data structure for loot
3. **Boons System** (MVP, Foundation) — Data structure for power-ups
4. **Input System** (MVP, Foundation) — Player control setup
5. **Health System** (MVP, Core) — Player survival mechanics
6. **Luck System** (MVP, Core) ⚠️ **HIGH-RISK** — Central mechanic; affects game feel
7. **Curse System** (MVP, Core) — Risk mechanics tied to Luck
8. **Damage/Combat Resolution** (MVP, Core) — Combat outcome logic
9. **Combat System** (MVP, Feature) ⚠️ **HIGH-RISK** — Core player interaction
10. **Enemy/Encounter System** (MVP, Feature) ⚠️ **HIGH-RISK** — Challenges and content
11. **Loot Generation** (MVP, Feature) — Item/boon drops
12. **Death/Run End Conditions** (MVP, Feature) — Run closure
13. **Permanent Progression** (MVP, Feature) — Meta-progression
14. **Run HUD** (MVP, Presentation) — Player information display
15. **Main Menu** (MVP, Presentation) — Game entry point
16. **Audio System** (MVP, Polish) — Music and SFX
17. **Visual Effects System** (Vertical Slice, Polish) — Green chaos aesthetic
18. **Feedback System** (Vertical Slice, Polish) — Screenshake and impact
19. **Procedural Generation** (Vertical Slice, Feature) — True roguelike replayability
20. **Boon Selection UI** (Vertical Slice, Presentation) — Interactive upgrades
21. **Inventory/Equipment UI** (Vertical Slice, Presentation) — Item management
22. **Run Summary Screen** (Vertical Slice, Presentation) — End-of-run display
23. **Settings Menu** (Alpha, Presentation) — Options
24. **Localization** (Alpha, Foundation) — Translation support

---

## Design Priority Tiers

### MVP — Core Loop Playable
**Scope**: 16 systems. Focuses on making one complete run from start to finish functional, with progression tracking.

**What ships**:
- Playable character with stats, health, items, boons
- Combat loop against enemies
- Loot drops and progression
- Permanent upgrades visible in main menu
- Run HUD showing current state
- No procedural generation (hardcoded rooms/encounters okay)

**What's deliberately excluded**:
- Visual polish (basic is OK)
- UI nice-to-haves (Settings, detailed Inventory)
- Procedural generation

---

### Vertical Slice — Polished Loop + Roguelike
**Scope**: Add 6 systems. Makes the game feel "complete" and roguelike.

**What ships**:
- Visual effects (green glow, chaos particles)
- Feedback systems (screenshake, damage numbers)
- Procedural generation (true randomization)
- Boon selection UI (active decision-making mid-run)
- Inventory UI (item management)
- Run summary screen (post-run review)

**What's still excluded**:
- Settings menu
- Localization

---

### Alpha & Beyond
**Scope**: Polish tier + optional features.

**Included**:
- Settings menu (difficulty, accessibility)
- Localization prep

---

## Dependency Graph

```
┌─ Foundation Layer
│  ├─ Stats System
│  ├─ Items System
│  ├─ Boons System
│  ├─ Input System
│  ├─ Audio System
│  └─ Localization
│
├─ Core Layer (builds on Foundation)
│  ├─ Health System
│  ├─ Luck System ◄─── BOTTLENECK (many depend)
│  ├─ Curse System ◄─── depends on Luck System
│  └─ Damage/Combat Resolution ◄─── depends on Health + Luck
│
├─ Feature Layer (builds on Core)
│  ├─ Combat System ◄─── depends on Damage, Enemy, Luck ◄─── BOTTLENECK
│  ├─ Enemy/Encounter System ◄─── depends on Combat, Loot ◄─── BOTTLENECK
│  ├─ Loot Generation ◄─── depends on Items, Boons, Luck
│  ├─ Death/Run End ◄─── depends on Health, Progression
│  ├─ Permanent Progression ◄─── depends on Save/Load
│  └─ Procedural Generation ◄─── depends on Enemy/Encounter, Loot
│
├─ Presentation Layer (wraps gameplay)
│  ├─ Run HUD ◄─── displays Stats, Health, Luck, Curse, Items
│  ├─ Main Menu ◄─── displays Save/Load, Progression
│  ├─ Boon Selection UI ◄─── displays Boons
│  ├─ Inventory UI ◄─── displays Items
│  ├─ Run Summary ◄─── displays all gameplay
│  └─ Settings Menu ◄─── standalone UI
│
└─ Polish Layer (feedback and feel)
   ├─ Visual Effects System ◄─── standalone
   └─ Feedback System ◄─── depends on Audio, Visual Effects
```

---

## High-Risk Systems

These systems have high interdependency or affect game feel significantly:

### 1. Luck System (Priority: MVP, Risk: HIGH)
- **Why risky**: Central mechanic affecting probabilities, curses, loot, and combat outcomes. Changes here ripple through the entire game.
- **Mitigation**: Design early, prototype with balance tests, get player feedback on chaos level.

### 2. Combat System (Priority: MVP, Risk: HIGH)
- **Why risky**: Core player interaction loop. Poor combat feels kill roguelikes.
- **Mitigation**: Play-test frequently with varied enemy types. Ensure responsive feedback.

### 3. Enemy/Encounter System (Priority: MVP, Risk: HIGH)
- **Why risky**: Generates challenge and content. Boring encounters kill engagement.
- **Mitigation**: Vary enemy types and abilities. Test difficulty curve. Tie to Luck System for dynamic challenge.

---

## Notes

- **Save/Load System** is foundational infrastructure; not listed in ordered design queue but must exist before any persistence work.
- **Leaf Nodes** (no dependents): Settings Menu, Localization, Boon Selection UI — can be designed or deferred late.
- **Circular Dependencies**: None detected. Graph is acyclic.
- **Concept Gaps**: Core Loop and MVP Definition are intentionally minimal in game-concept.md; they will be fully defined in individual system GDDs.

---

## Next Steps

1. **Design individual systems** using `/design-system [system-name]`:
   - Run `/design-system "Stats System"` to start
   - Each system writes a full GDD (8 required sections)
   - GDDs cross-reference dependencies
2. **Prototype high-risk systems** early: Luck System, Combat System
3. **Review for balance**: After Luck System and Loot Generation are designed, balance-check the progression curve
4. **Gate-check pre-production**: Run `/gate-check pre-production` after first 5-6 systems are designed to confirm readiness

---

## Progress Tracker

| # | System | Status | GDD File | Notes |
|---|--------|--------|----------|-------|
| 1 | Stats System | Not Started | `design/gdd/stats-system.md` | — |
| 2 | Items System | Not Started | `design/gdd/items-system.md` | — |
| 3 | Boons System | Not Started | `design/gdd/boons-system.md` | — |
| 4 | Input System | Not Started | `design/gdd/input-system.md` | — |
| 5 | Health System | Not Started | `design/gdd/health-system.md` | — |
| 6 | Luck System | Not Started | `design/gdd/luck-system.md` | **HIGH-RISK** |
| 7 | Curse System | Not Started | `design/gdd/curse-system.md` | — |
| 8 | Damage/Combat Resolution | Not Started | `design/gdd/damage-system.md` | — |
| 9 | Combat System | Not Started | `design/gdd/combat-system.md` | **HIGH-RISK** |
| 10 | Enemy/Encounter System | Not Started | `design/gdd/enemy-system.md` | **HIGH-RISK** |
| 11 | Loot Generation | Not Started | `design/gdd/loot-generation.md` | — |
| 12 | Death/Run End Conditions | Not Started | `design/gdd/run-end-conditions.md` | — |
| 13 | Permanent Progression | Not Started | `design/gdd/progression-system.md` | — |
| 14 | Run HUD | Not Started | `design/gdd/run-hud.md` | — |
| 15 | Main Menu | Not Started | `design/gdd/main-menu.md` | — |
| 16 | Audio System | Not Started | `design/gdd/audio-system.md` | — |
| 17 | Visual Effects System | Not Started | `design/gdd/visual-effects-system.md` | — |
| 18 | Feedback System | Not Started | `design/gdd/feedback-system.md` | — |
| 19 | Procedural Generation | Not Started | `design/gdd/procedural-generation.md` | — |
| 20 | Boon Selection UI | Not Started | `design/gdd/boon-selection-ui.md` | — |
| 21 | Inventory/Equipment UI | Not Started | `design/gdd/inventory-ui.md` | — |
| 22 | Run Summary Screen | Not Started | `design/gdd/run-summary.md` | — |
| 23 | Settings Menu | Not Started | `design/gdd/settings-menu.md` | — |
| 24 | Localization | Not Started | `design/gdd/localization.md` | — |
