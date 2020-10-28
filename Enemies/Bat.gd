extends KinematicBody2D

const FRICTION = 200
const KNOCKBACK_SPEED = 100

var knockback = Vector2.ZERO
var dead = false
onready var stats = $Stats


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	if (knockback == Vector2.ZERO && dead): 
		queue_free()

func _on_Hurtbox_area_entered(area):
	stats.register_hit(area.damage)
	knockback = area.knockback_vector * KNOCKBACK_SPEED


func _on_Stats_no_health():
	dead = true
