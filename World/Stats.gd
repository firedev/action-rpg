extends Node

export var max_health = 1
onready var health = max_health setget set_health

func set_health(new_health):
	health = new_health
	emit_signal("health_changed")
	if health <= 0:
		emit_signal("no_health")
		
func register_hit(damage = 1):
	set_health(health - damage)
	
signal no_health
signal health_changed
