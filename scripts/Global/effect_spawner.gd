extends Node

var effect_scene: PackedScene = preload("res://scenes/effects/fish_collect_effect.tscn")

func spawn_effect(target_pos: Vector2):
	var effect = effect_scene.instantiate()
	
	# define a posição
	effect.global_position = target_pos
	
	# adiciona na cena (usa o root atual)
	get_tree().current_scene.add_child(effect)
