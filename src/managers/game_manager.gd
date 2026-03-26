## Game Manager
## Main game loop coordinator
## Handles run state, encounters, and high-level game flow

extends Node
class_name GameManager

var player: Node
var enemy_spawner: Node
var current_room: int = 0
var run_active: bool = false
var enemies_spawned: int = 0
var boss_spawned: bool = false

func _ready() -> void:
	print("=== GAMEMANAGER READY ===")

	# Create camera
	print("Creating camera...")
	var camera = Camera2D.new()
	camera.global_position = Vector2(640, 360)
	add_child(camera)
	camera.make_current()
	print("Camera created and made current")

	# Create player FIRST (before UI)
	print("Creating player...")
	player = CharacterBody2D.new()
	player.script = preload("res://src/systems/player.gd")
	player.position = Vector2(640, 360)
	add_child(player)
	print("Player created")

	# Create UI manager AFTER player
	print("Creating UI manager...")
	var ui_manager = UIManager.new()
	ui_manager.player = player
	add_child(ui_manager)
	print("UI manager created")

	# Create enemy spawner
	print("Creating enemy spawner...")
	enemy_spawner = Node2D.new()
	enemy_spawner.script = preload("res://src/managers/enemy_spawner.gd")
	add_child(enemy_spawner)
	print("Enemy spawner created")

	# Call start_run directly (avoid await issues)
	call_deferred("start_run")
	print("start_run queued")

func start_run() -> void:
	print("=== Starting Run ===")
	run_active = true
	current_room = 0
	player.stats.current_health = player.stats.max_health
	player.enemy_spawner = enemy_spawner
	print("Player stats initialized: Health=%d, Attack=%d, Defense=%d, Luck=%d" % [
		player.stats.current_health,
		player.stats.attack_power,
		player.stats.defense,
		player.stats.luck
	])

	# Spawn initial enemies for testing
	spawn_enemy_wave()

func spawn_enemy_wave() -> void:
	var spawn_positions = [
		Vector2(300, 300),
		Vector2(900, 300),
	]

	for pos in spawn_positions:
		var enemy = enemy_spawner.spawn_enemy(pos, 30, 5)
		enemy.target = player
		enemies_spawned += 1
		print("Spawned enemy #%d" % enemies_spawned)

func _physics_process(_delta: float) -> void:
	if not run_active:
		return

	# Check for run end conditions
	if player.stats.current_health <= 0:
		end_run_death()
		return

	# Check if all enemies defeated
	var remaining_enemies = enemy_spawner.get_all_enemies()
	if remaining_enemies.is_empty() and enemies_spawned > 0:
		end_run_victory()

func end_run_death() -> void:
	print("=== Run Ended (Death) ===")
	run_active = false

func end_run_victory() -> void:
	print("=== Run Ended (Victory) ===")
	run_active = false
