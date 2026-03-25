## Bootstrap - starts the game as an autoload
## This bypasses scene file issues entirely

extends Node

func _ready() -> void:
	print("=== Game Starting ===")
	await get_tree().process_frame

	# Create manager
	var manager = GameManager.new()
	add_child(manager)
