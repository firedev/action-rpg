extends KinematicBody2D

const FRICTION = 200
const KNOCKBACK_SPEED = 200
const MAX_SPEED = 80
const ACCELERATION = 250
const WANDER_RANGE = 4

var knockback = Vector2.ZERO
var velocity  = Vector2.ZERO
var dead = false
var state = IDLE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $Bat
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

const Effect = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	CHASE,
	WANDER,
}

func _ready():
	randomize_behavior()

func create_effect():
	var effect = Effect.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	if (dead): 
		create_effect()
		queue_free()
	
	match(state):
		IDLE:
			velocity = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				randomize_behavior()

		WANDER:
			seek_player()
			accelerate_towards_point(wanderController.target_position, delta)
			
			if wanderController.get_time_left() == 0:
				randomize_behavior()

			if global_position.distance_to(wanderController.target_position) <= WANDER_RANGE:
				randomize_behavior()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * KNOCKBACK_SPEED * 2
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity =  velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
			

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.register_hit(area.damage)
	knockback = area.knockback_vector * KNOCKBACK_SPEED
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func randomize_behavior():
	state = pick_random_state([ IDLE, WANDER ])
	wanderController.start_wander_timer(rand_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Stats_no_hearts():
	dead = true


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
