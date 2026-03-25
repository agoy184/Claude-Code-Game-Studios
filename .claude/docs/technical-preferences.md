# Technical Preferences

<!-- Populated by /setup-engine. Updated as the user makes decisions throughout development. -->
<!-- All agents reference this file for project-specific standards and conventions. -->

## Engine & Language

- **Engine**: Godot 4.6
- **Language**: GDScript (primary)
- **Rendering**: Godot 2D (Canvas Renderer via D3D12 on Windows)
- **Physics**: Godot Physics 2D (default)

## Naming Conventions

- **Classes**: PascalCase (e.g., `PlayerController`, `ItemManager`)
- **Variables**: snake_case (e.g., `move_speed`, `max_health`)
- **Signals/Events**: snake_case past tense (e.g., `health_changed`, `item_acquired`)
- **Files**: snake_case matching class (e.g., `player_controller.gd`)
- **Scenes**: PascalCase matching root node (e.g., `PlayerController.tscn`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_HEALTH`, `DEFAULT_SPEED`)

## Performance Budgets

- **Target Framerate**: 60 FPS
- **Frame Budget**: 16.6 ms per frame
- **Draw Calls**: Minimize via batching (typical 2D roguelike: ~30-50 draw calls)
- **Memory Ceiling**: ~200 MB target (jam submission friendly)

## Testing

- **Framework**: GUT (Godot Unit Testing)
- **Minimum Coverage**: Jam entry—playtest-driven rather than unit-test-heavy
- **Required Tests**: Balance formulas (RNG, stat scaling), loot drop rates, progression unlocks

## Forbidden Patterns

<!-- Add patterns that should never appear in this project's codebase -->
- Hardcoded balance numbers (use external config files instead)
- Singletons for gameplay state (use proper signal connections)

## Allowed Libraries / Addons

<!-- Add approved third-party dependencies here -->
- GUT (Godot Unit Testing) — for balance formula tests
- None others added yet — prefer engine built-ins

## Architecture Decisions Log

<!-- Quick reference linking to full ADRs in docs/architecture/ -->
- [No ADRs yet — use /architecture-decision to create one]
