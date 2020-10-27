extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 400
const FRICTION = 400
enum {
	MOVE, 
	ROLL,
	ATTACK,
}

var velocity = Vector2.ZERO

var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	updateAnimationTrees(Vector2.RIGHT)
	animationTree.active=true
	
func _process(delta):
	match(state):
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
			
func roll_state(delta):
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
		
		if Input.is_action_just_pressed("roll"):
			state = ROLL
		animationState.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	velocity = move_and_slide(velocity)
	swordHitbox.knockback_vector = velocity.normalized()
