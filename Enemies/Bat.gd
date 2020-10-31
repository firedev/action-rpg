extends KinematicBody2D

const FRICTION = 200
const KNOCKBACK_SPEED = 200
const MAX_SPEED = 80
const ACCELERATION = 250

var knockback = Vector2.ZERO
var velocity  = Vector2.ZERO
var dead = false

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $Bat
onready var hurtbox = $Hurtbox

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
			velocity = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity =  velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	
		WANDER:
			pass
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
			
func _on_Hurtbox_area_entered(area):
	stats.register_hit(area.damage)
	knockback = area.knockback_vector * KNOCKBACK_SPEED
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	dead = true
