extends Area2D

const Effect = preload("res://Effects/HitEffect.tscn")

export (bool) var show_hit = true 

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = Effect.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = global_position
