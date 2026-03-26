## UI Manager
## Manages all UI elements (health bar, stats display, etc)

extends CanvasLayer
class_name UIManager

var player: Node
var health_label: Label
var health_bar: ColorRect
var bg_bar: ColorRect

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

	# Create background bar (dark red)
	bg_bar = ColorRect.new()
	bg_bar.position = Vector2(20, 20)
	bg_bar.size = Vector2(300, 30)
	bg_bar.color = Color(0.3, 0.1, 0.1, 0.8)
	add_child(bg_bar)

	# Create health bar (bright green)
	health_bar = ColorRect.new()
	health_bar.position = Vector2(20, 20)
	health_bar.size = Vector2(300, 30)
	health_bar.color = Color.GREEN
	add_child(health_bar)

	# Create health label
	health_label = Label.new()
	health_label.position = Vector2(30, 25)
	health_label.add_theme_font_size_override("font_size", 24)
	health_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(health_label)

	# Connect to health changes
	if player.stats:
		player.stats.health_changed.connect(_on_health_changed)
		_on_health_changed(player.stats.current_health, player.stats.max_health)

func _on_health_changed(current: int, max_val: int) -> void:
	print("UI: Health updated to %d/%d" % [current, max_val])

func _process(_delta: float) -> void:
	# Update health display every frame
	if player and health_label and health_bar:
		var current_health = player.stats.current_health
		var max_health = player.stats.max_health
		var luck = player.luck_system.get_luck() if player.luck_system else 0

		# Update health bar width
		var health_percent = float(current_health) / float(max_health)
		health_bar.size.x = 300 * health_percent

		# Update bar color based on health
		if health_percent > 0.5:
			health_bar.color = Color.GREEN
		elif health_percent > 0.25:
			health_bar.color = Color.YELLOW
		else:
			health_bar.color = Color.RED

		# Update label with health and luck
		health_label.text = "Health: %d/%d | Luck: %d" % [current_health, max_health, luck]
