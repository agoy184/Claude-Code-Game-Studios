## Combat Resolver
## Centralized combat resolution using lucky-influenced mechanics
## Handles: hit resolution, damage calculation, critical hits

extends Node
class_name CombatResolver

var attacker_luck: LuckSystem
var defender_stats: StatsSystem

signal combat_resolved(hit: bool, damage: int, is_critical: bool)

func _init(attacker: LuckSystem, defender: StatsSystem) -> void:
	attacker_luck = attacker
	defender_stats = defender

## Execute an attack with luck modifiers
func resolve_attack(attacker_damage: int) -> Dictionary:
	# Check if attack hits
	var hits = attacker_luck.attempt_hit()

	if not hits:
		print("  → MISS!")
		combat_resolved.emit(false, 0, false)
		return {"hit": false, "damage": 0, "critical": false}

	# Roll damage with luck variance
	var damage = attacker_luck.roll_damage(attacker_damage)

	# Check for critical hit
	var is_critical = attacker_luck.attempt_critical()

	if is_critical:
		damage = int(damage * attacker_luck.crit_multiplier)
		print("  → CRITICAL HIT! (%d damage)" % damage)
		attacker_luck.critical_hit.emit(damage)
	else:
		print("  → HIT! (%d damage)" % damage)

	combat_resolved.emit(true, damage, is_critical)
	return {"hit": true, "damage": damage, "critical": is_critical}
