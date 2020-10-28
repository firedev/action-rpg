extends Node

export var max_health = 1
onready var health = max_health setget set_health

func set_health(new_health):
	health = new_health
	if health <= 0:
		emit_signal("no_health")
		
func register_hit():
	set_health(health - 1)
	
signal no_health
