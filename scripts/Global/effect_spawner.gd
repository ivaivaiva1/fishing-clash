extends Node

var effect_scene: PackedScene = preload("res://scenes/effects/fish_collect_effect.tscn")
var bubble_scene: PackedScene = preload("res://scenes/effects/bubble.tscn")
var collected_coin_scene: PackedScene = preload("res://scenes/effects/collected_coin.tscn")
var fish_spawner: Node2D

func spawn_effect(target_pos: Vector2, target_scale: float):
	var effect = effect_scene.instantiate()
	
	# define a posição
	effect.global_position = target_pos
	effect.scale = Vector2(target_scale, target_scale)
	
	# adiciona na cena (usa o root atual)
	get_tree().current_scene.add_child(effect)


func spawn_bubble(target_pos: Vector2, target_scale: float, target_ordering: int):
	var effect = bubble_scene.instantiate()
	
	effect.global_position = target_pos
	effect.scale = Vector2(target_scale, target_scale)
	
	var sprite = effect.get_node("Sprite")
	sprite.z_index = target_ordering 
	
	fish_spawner.add_child(effect)


func collect_coin_effect(target_pos: Vector2):
	var effect = collected_coin_scene.instantiate()
	effect.global_position = target_pos
	fish_spawner.add_child(effect)
