## Bootstrap - starts the game
extends Node

func _ready() -> void:
	print("=== BOOTSTRAP READY ===")

	# Create GameManager
	var manager = GameManager.new()
	add_child(manager)
