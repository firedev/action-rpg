extends KinematicBody2D

const FRICTION = 200
const KNOCKBACK_SPEED = 100

var knockback = Vector2.ZERO
var velocity  = Vector2.ZERO
var dead = false
onready var stats = $Stats

const Effect = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	CHASE,
	WANDER,
}

var state = IDLE 

func create_effect():
	var effect = Effect.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	if (knockback == Vector2.ZERO && dead): 
		create_effect()
		queue_free()
	
	match(state):
		IDLE:
			pass
		CHASE:
			pass
		WANDER:
			pass
	
func _on_Hurtbox_area_entered(area):
	stats.register_hit(area.damage)
	knockback = area.knockback_vector * KNOCKBACK_SPEED


func _on_Stats_no_health():
	dead = true
