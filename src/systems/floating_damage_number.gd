## Floating Damage Number
## Pops up when damage is dealt, drifts upward and fades

extends Node2D
class_name FloatingDamageNumber

@export var lifetime: float = 1.0
@export var drift_speed: float = 50.0

var elapsed: float = 0.0
var label: Label

func _ready() -> void:
	# Create label
	label = Label.new()
	label.text = ""
	label.add_theme_font_size_override("font_size", 24)
	label.position = Vector2(-20, -20)
	add_child(label)

func show_damage(amount: int, is_critical: bool = false) -> void:
	if is_critical:
		label.text = "CRIT! %d" % amount
		label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		label.text = "%d" % amount
		label.add_theme_color_override("font_color", Color.WHITE)

func _process(delta: float) -> void:
	elapsed += delta

	# Drift upward
	position.y -= drift_speed * delta

	# Fade out
	var alpha = 1.0 - (elapsed / lifetime)
	if label:
		var color = label.get_theme_color("font_color")
		color.a = alpha
		label.add_theme_color_override("font_color", color)

	# Remove when done
	if elapsed >= lifetime:
		queue_free()
