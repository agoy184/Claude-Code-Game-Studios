## Enemy Types and their definitions

const TYPES = {
	"goblin": {
		"health": 20,
		"attack": 3,
		"defense": 0,
		"color": Color.LIGHT_GRAY,
		"speed": 120.0
	},
	"orc": {
		"health": 40,
		"attack": 6,
		"defense": 2,
		"color": Color.GREEN,
		"speed": 80.0
	},
	"troll": {
		"health": 60,
		"attack": 8,
		"defense": 3,
		"color": Color.DARK_GRAY,
		"speed": 60.0
	},
	"boss": {
		"health": 100,
		"attack": 10,
		"defense": 4,
		"color": Color.DARK_RED,
		"speed": 100.0
	}
}

static func get_type(type_name: String) -> Dictionary:
	return TYPES.get(type_name, TYPES["goblin"])
