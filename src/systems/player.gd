## Player Controller
## Represents the player character in the game
## Handles movement, animation, and coordination with stats

extends CharacterBody2D
class_name Player

@export var move_speed: float = 200.0
@export var attack_range: float = 40.0
@export var attack_cooldown: float = 0.5

var stats: StatsSystem
var velocity_direction: Vector2 = Vector2.ZERO
var can_attack: bool = true
var enemy_spawner: EnemySpawner

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready() -> void:
	# Create and attach stats system
	stats = StatsSystem.new()
	add_child(stats)

	# Connect to stat changes for visual feedback
	stats.health_changed.connect(_on_health_changed)
	stats.luck_changed.connect(_on_luck_changed)

	# Get reference to enemy spawner (will be set by GameManager)
	enemy_spawner = get_tree().root.get_child(0).get_node("EnemySpawner") if get_tree().root.get_child(0).has_node("EnemySpawner") else null

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

	# Handle attack input
	if Input.is_action_just_pressed("ui_accept") and can_attack:
		perform_attack()

	# Update attack cooldown
	if not can_attack:
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func take_damage(amount: int) -> void:
	stats.take_damage(amount)

func perform_attack() -> void:
	can_attack = false
	print("Player attacks with power: %d" % stats.attack_power)

	if enemy_spawner == null:
		can_attack = true
		return

	# Find nearby enemies
	var enemies = enemy_spawner.get_all_enemies()
	if enemies.is_empty():
		print("No enemies to attack")
		can_attack = true
		return

	# Attack the closest enemy in range
	var closest_enemy = null
	var closest_distance = attack_range

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	if closest_enemy:
		closest_enemy.take_damage(stats.attack_power)
		print("Hit enemy!")
	else:
		print("No enemies in attack range")

	can_attack = true

func _on_health_changed(new_health: int, max_health: int) -> void:
	# Update HUD or visual representation
	print("Health: %d/%d" % [new_health, max_health])

func _on_luck_changed(new_luck: int) -> void:
	print("Luck: %d" % new_luck)
