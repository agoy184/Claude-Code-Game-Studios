## Game Manager
## Main game loop coordinator
## Handles run state, encounters, and high-level game flow

extends Node
class_name GameManager

var player: Player
var current_room: int = 0
var run_active: bool = false

func _ready() -> void:
	player = $Player
	start_run()

func start_run() -> void:
	print("=== Starting Run ===")
	run_active = true
	current_room = 0
	player.stats.current_health = player.stats.max_health
	print("Player stats initialized: Health=%d, Attack=%d, Defense=%d, Luck=%d" % [
		player.stats.current_health,
		player.stats.attack_power,
		player.stats.defense,
		player.stats.luck
	])

func _physics_process(_delta: float) -> void:
	# Check for run end conditions
	if player.stats.current_health <= 0:
		end_run_death()

func end_run_death() -> void:
	print("=== Run Ended (Death) ===")
	run_active = false
	# TODO: Load run summary screen
