## Bootstrap - starts the game as an autoload
## This bypasses scene file issues entirely

extends Node

func _ready() -> void:
	print("=== BOOTSTRAP STARTED ===")

	# Create manager directly
	var manager = GameManager.new()
	add_child(manager)
	print("=== GAMEMANAGER INSTANTIATED ===")
