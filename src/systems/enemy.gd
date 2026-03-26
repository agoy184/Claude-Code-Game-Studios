## Enemy
## Represents an enemy NPC in the game
## Has stats and can take damage

extends CharacterBody2D
class_name Enemy

@export var move_speed: float = 100.0
@export var max_health: int = 30
@export var attack_power: int = 5
@export var defense: int = 0
@export var attack_cooldown: float = 1.5

var current_health: int
var target: Player
var collision_shape_2d: CollisionShape2D
var health_bar_container: Node2D
var health_bar: ColorRect
var health_label: Label
var can_attack: bool = true
var attack_timer: float = 0.0

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

	# Create health bar UI
	_create_health_bar()

	print("ENEMY: _ready complete")

func _physics_process(_delta: float) -> void:
	if not is_node_alive():
		return

	if target == null:
		return

	# Update attack cooldown
	if not can_attack:
		attack_timer -= _delta
		if attack_timer <= 0:
			can_attack = true

	# Simple AI: move toward player
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

	# Check if in attack range
	if global_position.distance_to(target.global_position) < 40 and can_attack:
		attack_player()

func attack_player() -> void:
	if target and is_node_alive():
		can_attack = false
		attack_timer = attack_cooldown
		target.take_damage(attack_power)

func take_damage(amount: int, is_critical: bool = false) -> void:
	var reduced_damage = max(1, amount - defense)
	current_health = max(0, current_health - reduced_damage)
	print("Enemy health: %d/%d" % [current_health, max_health])

	# Update health bar display
	_update_health_bar()

	# Show floating damage number
	_show_damage_feedback(reduced_damage, is_critical)

	if current_health <= 0:
		die()

func _show_damage_feedback(damage: int, is_critical: bool) -> void:
	# Create floating damage number at enemy position
	var damage_popup = FloatingDamageNumber.new()
	damage_popup.global_position = global_position
	get_parent().add_child(damage_popup)
	damage_popup.show_damage(damage, is_critical)

func _create_health_bar() -> void:
	# Create container for health bar UI
	health_bar_container = Node2D.new()
	health_bar_container.position = Vector2(0, -50)
	add_child(health_bar_container)

	# Create background bar (dark red)
	var bg_bar = ColorRect.new()
	bg_bar.position = Vector2(-20, 0)
	bg_bar.size = Vector2(40, 8)
	bg_bar.color = Color(0.3, 0.1, 0.1, 0.8)
	health_bar_container.add_child(bg_bar)

	# Create health bar (bright green)
	health_bar = ColorRect.new()
	health_bar.position = Vector2(-20, 0)
	health_bar.size = Vector2(40, 8)
	health_bar.color = Color.GREEN
	health_bar_container.add_child(health_bar)

	# Create health label
	health_label = Label.new()
	health_label.position = Vector2(-25, -20)
	health_label.add_theme_font_size_override("font_size", 16)
	health_label.add_theme_color_override("font_color", Color.WHITE)
	health_bar_container.add_child(health_label)

	_update_health_bar()

func _update_health_bar() -> void:
	if health_bar and health_label:
		# Update bar width based on health percentage
		var health_percent = float(current_health) / float(max_health)
		health_bar.size.x = 40 * health_percent

		# Update color based on health
		if health_percent > 0.5:
			health_bar.color = Color.GREEN
		elif health_percent > 0.25:
			health_bar.color = Color.YELLOW
		else:
			health_bar.color = Color.RED

		# Update label
		health_label.text = "%d/%d" % [current_health, max_health]

func die() -> void:
	print("Enemy died")
	died.emit()
	queue_free()

func is_node_alive() -> bool:
	return not is_queued_for_deletion() and current_health > 0
