extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var MAX_SPEED = 100
export var ACCELERATION = 400
export var FRICTION = 400

enum {
	MOVE, 
	ROLL,
	ATTACK,
}

var velocity = Vector2.ZERO

var state = MOVE

onready var stats = PlayerStats
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	stats.connect("no_hearts", self, "queue_free")
	updateAnimationTrees(Vector2.RIGHT)
	animationTree.active=true
	
func _process(delta):
	match(state):
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state(delta)
			
func roll_state():
	animationState.travel("Roll")
	velocity = move_and_slide(velocity.normalized() * MAX_SPEED)

func roll_finished():
	state = MOVE
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_finished():
	state = MOVE

func updateAnimationTrees(input_vector):
	animationTree.set("parameters/Idle/blend_position", input_vector)
	animationTree.set("parameters/Run/blend_position", input_vector)
	animationTree.set("parameters/Attack/blend_position", input_vector)
	animationTree.set("parameters/Roll/blend_position", input_vector)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		updateAnimationTrees(input_vector)	
		velocity = velocity.move_toward(input_vector.normalized() * MAX_SPEED, ACCELERATION * delta)
		swordHitbox.knockback_vector = velocity.normalized()
		if Input.is_action_just_pressed("roll"):
			state = ROLL
		animationState.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area):
	stats.register_hit(area.damage)
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
