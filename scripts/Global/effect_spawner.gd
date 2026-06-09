extends Node

var effect_scene: PackedScene = preload("res://_scenes/effects/fish_collect_effect.tscn")
var bubble_scene: PackedScene = preload("res://_scenes/effects/bubble.tscn")
var collected_coin_scene: PackedScene = preload("res://_scenes/effects/collected_coin.tscn")
var blood_scene: PackedScene = preload("res://_scenes/effects/blood.tscn")
var fish_spawner: Node2D


func spawn_blood(shark: Shark, target_pos: Vector2, flip_h: bool, flip_v: bool):
	var blood_instance = blood_scene.instantiate()
	shark.add_child(blood_instance)
	blood_instance.global_position = target_pos
	if flip_v || flip_h:
		for child in blood_instance.get_children():
			if child is Sprite2D:
				child.flip_h = flip_h
				child.flip_v = flip_v
				break


func spawn_effect(target_pos: Vector2, target_scale: float):
	var effect = effect_scene.instantiate()
	get_tree().current_scene.add_child(effect)
	# define a posição
	effect.global_position = target_pos
	effect.scale = Vector2(target_scale, target_scale)
	
	# adiciona na cena (usa o root atual)


func spawn_bubble(target_pos: Vector2, target_scale: float, target_ordering: int):
	var effect = bubble_scene.instantiate()
	
	
	fish_spawner.add_child(effect)
	effect.scale = Vector2(target_scale, target_scale)
	effect.global_position = target_pos
	var sprite = effect.get_node("Sprite")
	sprite.z_index = target_ordering 


func collect_coin_effect(target_pos: Vector2):
	var effect = collected_coin_scene.instantiate()
	fish_spawner.add_child(effect)
	effect.global_position = target_pos


enum DEFAULT_EFFECTS{
	BLOOD 
}
