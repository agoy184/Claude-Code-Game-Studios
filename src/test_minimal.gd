## Minimal test - just see if this runs
extends Node

func _ready() -> void:
	print("TEST: Script loaded successfully")
	print("TEST: Creating empty node")
	var node = Node.new()
	add_child(node)
	print("TEST: Node created and added")
