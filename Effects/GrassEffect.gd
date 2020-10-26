extends Node2D

onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.play("Grass")

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		_ready()


func _on_AnimatedSprite_animation_finished():
	queue_free()
	
