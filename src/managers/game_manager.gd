## Game Manager
## Main game loop coordinator
## Handles run state, encounters, and high-level game flow

extends Node
class_name GameManager

var player: Player
var enemy_spawner: EnemySpawner
var current_room: int = 0
var run_active: bool = false
var enemies_spawned: int = 0

func _ready() -> void:
	# Create player
	player = CharacterBody2D.new()
	player.script = preload("res://src/systems/player.gd")
	player.position = Vector2(640, 360)
	add_child(player)

	# Create enemy spawner
	enemy_spawner = Node2D.new()
	enemy_spawner.script = preload("res://src/managers/enemy_spawner.gd")
	add_child(enemy_spawner)

	# Wait for nodes to be ready
	await get_tree().process_frame

	start_run()

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
