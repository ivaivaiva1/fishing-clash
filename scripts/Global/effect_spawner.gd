extends Node

var effect_scene: PackedScene = preload("res://scenes/effects/fish_collect_effect.tscn")

func spawn_effect(target_pos: Vector2, target_scale: float):
	var effect = effect_scene.instantiate()
	
	# define a posição
	effect.global_position = target_pos
	effect.scale = Vector2(target_scale, target_scale)
	
	# adiciona na cena (usa o root atual)
	get_tree().current_scene.add_child(effect)
