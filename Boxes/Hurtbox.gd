extends Area2D

const Effect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

onready var timer = $Timer

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	if invincible == false:
		self.invincible = true
		timer.start(duration)
	
func create_hit_effect():
	var effect = Effect.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.invincible = false # Replace with function body.

func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)
	collisionShape.set_deferred("disabled", true)
	
func _on_Hurtbox_invincibility_ended():
	monitoring = true
	collisionShape.disabled = false
