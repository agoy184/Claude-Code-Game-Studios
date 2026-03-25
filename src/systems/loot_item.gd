## Loot Item
## Represents an item dropped in the world that can be picked up

extends Area2D
class_name LootItem

@export var item_type: String = "gold"
@export var amount: int = 10

var collected: bool = false

func _ready() -> void:
	# Create visual (yellow square for gold)
	var visual = ColorRect.new()
	visual.name = "Visual"
	visual.size = Vector2(16, 16)
	visual.position = Vector2(-8, -8)
	visual.color = Color.YELLOW
	add_child(visual)

	# Create collision
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 12.0
	collision.shape = shape
	add_child(collision)

	# Connect signals
	area_entered.connect(_on_area_entered)
	print("Item spawned: %s x%d at (%.0f, %.0f)" % [item_type, amount, position.x, position.y])

func _on_area_entered(area: Area2D) -> void:
	if collected:
		return

	# Check if player picked it up
	if area is Player or (area.get_parent() is Player):
		collect()

func collect() -> void:
	if collected:
		return

	collected = true
	print("Item collected: %s x%d" % [item_type, amount])

	# TODO: Add to player inventory

	queue_free()
