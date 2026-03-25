## Player Controller
## Represents the player character in the game
## Handles movement, animation, and coordination with stats

extends CharacterBody2D
class_name Player

@export var move_speed: float = 200.0
@export var attack_range: float = 100.0
@export var attack_cooldown: float = 0.5

var stats: StatsSystem
var luck_system: LuckSystem
var combat_resolver: CombatResolver
var velocity_direction: Vector2 = Vector2.ZERO
var can_attack: bool = true
var attack_timer: float = 0.0
var enemy_spawner: EnemySpawner
var collision_shape_2d: CollisionShape2D

func _ready() -> void:
	print("PLAYER: _ready called")

	# Create visual rect if not in scene
	if not has_node("Visual"):
		print("PLAYER: Creating ColorRect")
		var visual = ColorRect.new()
		visual.name = "Visual"
		visual.size = Vector2(32, 32)
		visual.position = Vector2(-16, -16)
		visual.color = Color.GREEN
		add_child(visual)

	# Create collision if not in scene
	if not has_node("CollisionShape2D"):
		print("PLAYER: Creating CollisionShape2D")
		collision_shape_2d = CollisionShape2D.new()
		collision_shape_2d.name = "CollisionShape2D"
		var shape = CapsuleShape2D.new()
		shape.radius = 16.0
		shape.height = 32.0
		collision_shape_2d.shape = shape
		add_child(collision_shape_2d)

	# Create pickup detection area
	if not has_node("PickupArea"):
		print("PLAYER: Creating pickup detection area")
		var pickup_area = Area2D.new()
		pickup_area.name = "PickupArea"
		var area_collision = CollisionShape2D.new()
		var area_shape = CircleShape2D.new()
		area_shape.radius = 40.0
		area_collision.shape = area_shape
		pickup_area.add_child(area_collision)
		pickup_area.area_entered.connect(_on_area_entered)
		add_child(pickup_area)

	print("PLAYER: Creating stats system")
	# Create and attach stats system
	stats = StatsSystem.new()
	add_child(stats)

	print("PLAYER: Creating luck system")
	# Create and attach luck system
	luck_system = LuckSystem.new()
	add_child(luck_system)
	luck_system.modify_luck(5)  # Start with 5 luck for testing

	print("PLAYER: Creating combat resolver")
	# Create combat resolver
	combat_resolver = CombatResolver.new(luck_system, stats)
	add_child(combat_resolver)

	print("PLAYER: Connecting signals")
	# Connect to stat changes for visual feedback
	stats.health_changed.connect(_on_health_changed)
	stats.luck_changed.connect(_on_luck_changed)
	luck_system.luck_changed.connect(_on_luck_value_changed)

	print("PLAYER: Finding enemy spawner")
	# Get reference to enemy spawner parent node
	var parent = get_parent()
	if parent and parent.has_node("EnemySpawner"):
		enemy_spawner = parent.get_node("EnemySpawner")
		print("PLAYER: Enemy spawner found")
	else:
		print("PLAYER: Enemy spawner NOT found")

	print("PLAYER: _ready complete")

func _physics_process(delta: float) -> void:
	# Get input
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * move_speed
		velocity_direction = input_vector
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Update attack cooldown timer
	if not can_attack:
		attack_timer -= delta
		if attack_timer <= 0:
			can_attack = true

	# Handle attack input
	if Input.is_action_just_pressed("ui_accept") and can_attack:
		perform_attack()

	# Redraw to update range indicator
	queue_redraw()

func _draw() -> void:
	# Draw attack range circle (semi-transparent)
	draw_circle(Vector2.ZERO, attack_range, Color(1, 1, 0, 0.1))

func take_damage(amount: int) -> void:
	stats.take_damage(amount)

func perform_attack() -> void:
	can_attack = false
	attack_timer = attack_cooldown
	print("Player attacks! (Luck: %d, Hit Chance: %.0f%%)" % [
		luck_system.get_luck(),
		luck_system.calculate_hit_chance() * 100
	])

	if enemy_spawner == null:
		print("No enemy spawner found")
		return

	# Find nearby enemies
	var enemies = enemy_spawner.get_all_enemies()
	if enemies.is_empty():
		print("No enemies to attack")
		return

	# Attack the closest enemy in range
	var closest_enemy = null
	var closest_distance = attack_range

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		print("  Distance to enemy: %.1f (range: %.1f)" % [distance, attack_range])
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	if closest_enemy:
		# Resolve attack with luck
		var result = combat_resolver.resolve_attack(stats.attack_power)
		if result["hit"]:
			closest_enemy.take_damage(result["damage"], result["critical"])
		else:
			print("Attack missed!")
	else:
		print("No enemies in attack range (closest was %.1f away)" % closest_distance)

func _on_health_changed(new_health: int, max_health: int) -> void:
	# Update HUD or visual representation
	print("Health: %d/%d" % [new_health, max_health])

func _on_luck_changed(new_luck: int) -> void:
	print("Luck stat: %d" % new_luck)

func _on_luck_value_changed(new_luck: int) -> void:
	print("Luck value changed to: %d (hit chance: %.0f%%)" % [new_luck, luck_system.calculate_hit_chance() * 100])

func _on_area_entered(area: Area2D) -> void:
	if area is LootItem:
		print("Player collided with loot!")
		area.collect()
