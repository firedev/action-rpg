extends Node

export var max_hearts : int = 1
var hearts : int setget set_hearts

func set_hearts(new_hearts):
	hearts = new_hearts
	emit_signal("hearts_changed", hearts)
	if hearts <= 0:
		emit_signal("no_hearts")
		
func register_hit(damage = 1):
	set_hearts(hearts - damage)
	
func _ready():
	self.hearts = max_hearts
	
signal no_hearts
signal hearts_changed(value)
