extends Control

var hearts : int setget set_hearts
var max_hearts : int setget set_max_hearts

const stats = PlayerStats
onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty
onready var label = $Label

onready var width = int(heartUIFull.texture.get_size().x)

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	
func set_max_hearts(value):
	max_hearts = max(value, 0)

func update_label(hearts):
	heartUIFull.rect_size.x = hearts * width
	heartUIEmpty.rect_size.x = stats.max_hearts * width
	if label != null:
		label.text = str(stats.hearts)
	
func _ready():
	self.max_hearts = stats.max_hearts
	self.hearts = stats.max_hearts
	update_label(hearts)
	stats.connect("hearts_changed", self, "update_label")
	
