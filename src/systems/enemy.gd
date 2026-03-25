## Enemy
## Represents an enemy NPC in the game
## Has stats and can take damage

extends CharacterBody2D
class_name Enemy

@export var move_speed: float = 100.0
@export var max_health: int = 30
@export var attack_power: int = 5
@export var defense: int = 0

var current_health: int
var target: Player
var sprite_2d: Sprite2D
var collision_shape_2d: CollisionShape2D

signal died

func _ready() -> void:
	current_health = max_health

	# Create sprite if not in scene
	if not has_node("Sprite2D"):
		sprite_2d = Sprite2D.new()
		sprite_2d.name = "Sprite2D"
		sprite_2d.scale = Vector2(2, 2)
		sprite_2d.self_modulate = Color.RED
		add_child(sprite_2d)
	else:
		sprite_2d = $Sprite2D

	# Create collision if not in scene
	if not has_node("CollisionShape2D"):
		collision_shape_2d = CollisionShape2D.new()
		collision_shape_2d.name = "CollisionShape2D"
		var shape = CapsuleShape2D.new()
		shape.radius = 16.0
		shape.height = 32.0
		collision_shape_2d.shape = shape
		add_child(collision_shape_2d)
	else:
		collision_shape_2d = $CollisionShape2D

	if sprite_2d:
		sprite_2d.modulate = Color.RED

func _physics_process(delta: float) -> void:
	if not is_node_alive():
		return

	if target == null:
		return

	# Simple AI: move toward player
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

	# Check if in attack range (simple collision)
	if global_position.distance_to(target.global_position) < 40:
		attack_player()

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
	queue_free()

func is_node_alive() -> bool:
	return not is_queued_for_deletion() and current_health > 0
