extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# if Input.is_action_just_pressed("attack"):

func create_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	print(area.get_node("../").name)
	if (area.get_node("../").name == "HitboxPivot"):
		create_grass_effect()
		queue_free() 
