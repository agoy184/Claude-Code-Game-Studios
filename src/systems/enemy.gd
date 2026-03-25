## Enemy
## Represents an enemy NPC in the game
## Has stats and can take damage

extends CharacterBody2D
class_name Enemy

@export var move_speed: float = 100.0
@export var max_health: int = 30
@export var attack_power: int = 5
@export var defense: int = 0
@export var attack_range: float = 60.0
@export var attack_cooldown: float = 1.0

var current_health: int
var target: Player
var collision_shape_2d: CollisionShape2D
var attack_timer: float = 0.0
var spawner: Node

signal died

func _ready() -> void:
	print("ENEMY: _ready called")
	current_health = max_health

	# Create visual rect if not in scene
	if not has_node("Visual"):
		print("ENEMY: Creating ColorRect")
		var visual = ColorRect.new()
		visual.name = "Visual"
		visual.size = Vector2(32, 32)
		visual.position = Vector2(-16, -16)
		visual.color = Color.RED
		add_child(visual)

	# Create collision if not in scene
	if not has_node("CollisionShape2D"):
		print("ENEMY: Creating CollisionShape2D")
		collision_shape_2d = CollisionShape2D.new()
		collision_shape_2d.name = "CollisionShape2D"
		var shape = CapsuleShape2D.new()
		shape.radius = 16.0
		shape.height = 32.0
		collision_shape_2d.shape = shape
		add_child(collision_shape_2d)
	else:
		collision_shape_2d = $CollisionShape2D

	print("ENEMY: _ready complete")

func _physics_process(delta: float) -> void:
	if not is_node_alive():
		return

	if target == null:
		return

	# Update attack cooldown
	if attack_timer > 0:
		attack_timer -= delta

	# Simple AI: move toward player
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

	# Check if in attack range
	var distance_to_target = global_position.distance_to(target.global_position)
	if distance_to_target < attack_range and attack_timer <= 0:
		attack_player()
		attack_timer = attack_cooldown

func attack_player() -> void:
	if target and is_node_alive():
		target.take_damage(attack_power)

func take_damage(amount: int) -> void:
	var reduced_damage = max(1, amount - defense)
	current_health = max(0, current_health - reduced_damage)
	print("Enemy health: %d/%d" % [current_health, max_health])

	if current_health <= 0:
		die()

func die() -> void:
	print("Enemy died")
	died.emit()

	# Signal spawner to drop loot
	if spawner:
		spawner.spawn_loot(global_position)

	queue_free()

func is_node_alive() -> bool:
	return not is_queued_for_deletion() and current_health > 0
