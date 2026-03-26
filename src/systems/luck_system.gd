## Luck System
## Central mechanic affecting probabilities and chance events
## Influences: hit chance, damage variance, critical strikes, enemy behavior

extends Node
class_name LuckSystem

var luck_value: int = 0
var base_hit_chance: float = 0.8  # 80% base hit
var crit_multiplier: float = 1.5

signal luck_changed(new_value: int)
@warning_ignore("unused_signal")
signal critical_hit(damage: int)  # TODO: Listen to this for critical hit effects/feedback
signal miss_event

## Hit chance is modified by luck (soft cap at 95%)
func calculate_hit_chance() -> float:
	var luck_bonus = clamp(luck_value * 0.02, 0.0, 0.15)  # +2% per luck, cap at +15%
	return clamp(base_hit_chance + luck_bonus, 0.1, 0.95)

## Damage roll with variance affected by luck
## Higher luck = more consistent, better rolls
func roll_damage(base_damage: int) -> int:
	var variance = 0.2 - (luck_value * 0.01)  # Reduce variance by 1% per luck
	variance = clamp(variance, 0.05, 0.3)  # Variance between 5% and 30%

	var min_damage = int(base_damage * (1.0 - variance))
	var max_damage = int(base_damage * (1.0 + variance))

	return randi_range(min_damage, max_damage)

## Check if attack hits based on luck
func attempt_hit() -> bool:
	var hit_chance = calculate_hit_chance()
	var roll = randf()

	if roll > hit_chance:
		miss_event.emit()
		return false
	return true

## Check for critical hit based on luck
## Base crit chance scales with luck
func attempt_critical(base_crit_chance: float = 0.05) -> bool:
	var luck_crit_bonus = clamp(luck_value * 0.01, 0.0, 0.20)  # +1% per luck, cap at +20%
	var total_crit_chance = base_crit_chance + luck_crit_bonus

	return randf() < total_crit_chance

## Apply luck modification to a stat
func modify_luck(delta: int) -> void:
	luck_value += delta
	luck_changed.emit(luck_value)
	print("Luck modified to: %d" % luck_value)

func get_luck() -> int:
	return luck_value
