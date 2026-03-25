## Stats System
## Data structure for player attribute tracking
## These are the core numeric values that define the player's capabilities

extends Node
class_name StatsSystem

## Health
var max_health: int = 100
var current_health: int = 100

## Damage output
var attack_power: int = 10

## Armor / damage reduction
var defense: int = 0

## Luck - central mechanic, affects probability rolls
var luck: int = 0

## Signals for stat changes
signal health_changed(new_value: int, max_value: int)
signal luck_changed(new_value: int)
signal stat_modified(stat_name: String, new_value: int)

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	var reduced_damage = max(1, amount - defense)
	current_health = max(0, current_health - reduced_damage)
	health_changed.emit(current_health, max_health)

	if current_health == 0:
		print("Player died")

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func modify_stat(stat_name: String, delta: int) -> void:
	match stat_name:
		"luck":
			luck += delta
			luck_changed.emit(luck)
		"attack_power":
			attack_power += delta
		"defense":
			defense += delta
		"max_health":
			max_health += delta
			current_health = min(current_health, max_health)

	stat_modified.emit(stat_name, get_stat(stat_name))

func get_stat(stat_name: String) -> int:
	match stat_name:
		"health":
			return current_health
		"max_health":
			return max_health
		"luck":
			return luck
		"attack_power":
			return attack_power
		"defense":
			return defense
		_:
			return 0
