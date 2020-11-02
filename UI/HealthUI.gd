extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

const stats = PlayerStats
onready var label = $Label

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	
func set_max_hearts(value):
	max_hearts = max(value, 1)

func update_label():
	label.text = str(stats.health)
	
func _ready():
	self.max_hearts = stats.max_health
	self.hearts = stats.max_health
	update_label()
	stats.connect("health_changed", self, "update_label")


