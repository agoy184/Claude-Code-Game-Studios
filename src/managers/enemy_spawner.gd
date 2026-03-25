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

func spawn_enemy(position: Vector2, health: int = 30, attack: int = 5) -> Enemy:
	var enemy = Enemy.new()
	enemy.global_position = position
	enemy.max_health = health
	enemy.current_health = health
	enemy.attack_power = attack

	# Create visual representation
	var sprite = Sprite2D.new()
	sprite.self_modulate = Color.RED
	sprite.scale = Vector2(2, 2)

	var collision = CollisionShape2D.new()
	var shape = CapsuleShape2D.new()
	shape.radius = 16.0
	shape.height = 32.0
	collision.shape = shape

	enemy.add_child(sprite)
	enemy.add_child(collision)

	add_child(enemy)
	spawned_enemies.append(enemy)
	enemy.died.connect(_on_enemy_died.bindv([enemy]))

	return enemy

func _on_enemy_died(enemy: Enemy) -> void:
	spawned_enemies.erase(enemy)
	print("Enemies remaining: %d" % spawned_enemies.size())

func get_all_enemies() -> Array[Enemy]:
	return spawned_enemies
