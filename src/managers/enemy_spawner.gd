## Enemy Spawner
## Spawns enemies for testing and gameplay

extends Node2D
class_name EnemySpawner

@export var enemy_scene: PackedScene
var enemy_template: Enemy
var spawn_points: Array[Vector2] = [
	Vector2(300, 300),
	Vector2(900, 300),
	Vector2(300, 600),
	Vector2(900, 600),
]

var spawned_enemies: Array[Enemy] = []

func _ready() -> void:
	# Create a basic enemy template if none provided
	if enemy_scene == null:
		_create_default_enemy_template()

func _create_default_enemy_template() -> void:
	# This will be rendered as a simple red square
	enemy_template = Enemy.new()

func spawn_enemy(spawn_pos: Vector2, health: int = 30, attack: int = 5) -> Enemy:
	var enemy = Enemy.new()
	enemy.global_position = spawn_pos
	enemy.max_health = health
	enemy.current_health = health
	enemy.attack_power = attack
	enemy.spawner = self

	add_child(enemy)
	spawned_enemies.append(enemy)
	enemy.died.connect(_on_enemy_died.bindv([enemy]))

	return enemy

func _on_enemy_died(enemy: Enemy) -> void:
	spawned_enemies.erase(enemy)
	print("Enemies remaining: %d" % spawned_enemies.size())

func get_all_enemies() -> Array[Enemy]:
	return spawned_enemies

func spawn_loot(position: Vector2) -> void:
	print("Spawning loot at %.0f, %.0f" % [position.x, position.y])
	var loot = LootItem.new()
	loot.position = position
	loot.item_type = "gold"
	loot.amount = 10
	add_child(loot)
