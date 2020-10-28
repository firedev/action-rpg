extends KinematicBody2D

const FRICTION = 200
const KNOCKBACK_SPEED = 100

var knockback = Vector2.ZERO
onready var stats = $Stats

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	if (knockback == Vector2.ZERO && stats.health <= 0): 
		queue_free()

func _on_Hurtbox_area_entered(area):
	stats.health = stats.health - 1
	knockback = area.knockback_vector * KNOCKBACK_SPEED
