## Player Controller
## Represents the player character in the game
## Handles movement, animation, and coordination with stats

extends CharacterBody2D
class_name Player

@export var move_speed: float = 200.0

var stats: StatsSystem
var velocity_direction: Vector2 = Vector2.ZERO

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready() -> void:
	# Create and attach stats system
	stats = StatsSystem.new()
	add_child(stats)

	# Connect to stat changes for visual feedback
	stats.health_changed.connect(_on_health_changed)
	stats.luck_changed.connect(_on_luck_changed)

func _physics_process(delta: float) -> void:
	# Get input
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * move_speed
		velocity_direction = input_vector
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Update facing direction for sprite
	if velocity_direction != Vector2.ZERO:
		# Flip sprite if moving left
		if velocity_direction.x < 0:
			sprite_2d.flip_h = true
		elif velocity_direction.x > 0:
			sprite_2d.flip_h = false

func take_damage(amount: int) -> void:
	stats.take_damage(amount)

func _on_health_changed(new_health: int, max_health: int) -> void:
	# Update HUD or visual representation
	print("Health: %d/%d" % [new_health, max_health])

func _on_luck_changed(new_luck: int) -> void:
	print("Luck: %d" % new_luck)
