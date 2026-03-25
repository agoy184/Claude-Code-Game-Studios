## UI Manager
## Manages all UI elements (health bar, stats display, etc)

extends CanvasLayer
class_name UIManager

var player: Node
var health_label: Label

func _ready() -> void:
	print("=== UI MANAGER READY ===")

	# Get player reference from parent
	var parent = get_parent()
	if parent and parent.has_node("Player"):
		player = parent.get_node("Player")
		print("UI: Player found")
	else:
		print("UI: Player NOT found")
		return

	# Create health label
	health_label = Label.new()
	health_label.position = Vector2(20, 20)
	health_label.add_theme_font_size_override("font_size", 32)
	add_child(health_label)

	# Connect to health changes
	if player.stats:
		player.stats.health_changed.connect(_on_health_changed)
		_on_health_changed(player.stats.current_health, player.stats.max_health)

func _on_health_changed(current: int, max_val: int) -> void:
	if health_label:
		health_label.text = "Health: %d/%d" % [current, max_val]
		print("UI: Health updated to %d/%d" % [current, max_val])

func _process(_delta: float) -> void:
	# Update luck display too
	if player and health_label:
		var luck = player.luck_system.get_luck() if player.luck_system else 0
		health_label.text = "Health: %d/%d | Luck: %d" % [
			player.stats.current_health,
			player.stats.max_health,
			luck
		]
