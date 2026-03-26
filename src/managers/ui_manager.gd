## UI Manager
## Manages all UI elements (health bar, stats display, etc)

extends CanvasLayer
class_name UIManager

var player: Node
var health_label: Label
var health_bar: ColorRect
var bg_bar: ColorRect
var game_over_panel: Control
var is_game_over: bool = false

func _ready() -> void:
	print("=== UI MANAGER READY ===")

	# Player should be set by GameManager before this is called
	if not player:
		print("UI: Player NOT set!")
		return

	print("UI: Player found")

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

	print("UI: Ready complete")

func _on_health_changed(current: int, max_val: int) -> void:
	print("UI: Health updated to %d/%d" % [current, max_val])

	# Show game over if player dies
	if current <= 0 and not is_game_over:
		show_game_over()

func show_game_over() -> void:
	is_game_over = true
	print("=== GAME OVER ===")

	# Create semi-transparent overlay
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.7)
	overlay.size = get_viewport_rect().size
	overlay.position = Vector2.ZERO
	add_child(overlay)

	# Create game over panel
	game_over_panel = Control.new()
	game_over_panel.position = Vector2(640 - 250, 360 - 150)
	add_child(game_over_panel)

	# Title
	var title = Label.new()
	title.text = "GAME OVER"
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color.RED)
	title.position = Vector2(150, 50)
	game_over_panel.add_child(title)

	# Stats
	var stats_label = Label.new()
	stats_label.text = "You fought bravely!"
	stats_label.add_theme_font_size_override("font_size", 24)
	stats_label.add_theme_color_override("font_color", Color.WHITE)
	stats_label.position = Vector2(80, 130)
	game_over_panel.add_child(stats_label)

	# Restart button
	var restart_button = Button.new()
	restart_button.text = "Press SPACE to Restart"
	restart_button.position = Vector2(50, 200)
	restart_button.size = Vector2(400, 60)
	restart_button.add_theme_font_size_override("font_size", 20)
	game_over_panel.add_child(restart_button)

func _process(_delta: float) -> void:
	# Update health display every frame
	if player and health_label and health_bar and not is_game_over:
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

	# Check for restart
	if is_game_over and Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
