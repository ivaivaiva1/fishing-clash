extends Node

var effect_scene: PackedScene = preload("res://_scenes/effects/fish_collect_effect.tscn")
var bubble_scene: PackedScene = preload("res://_scenes/effects/bubble.tscn")
var collected_coin_scene: PackedScene = preload("res://_scenes/effects/collected_coin.tscn")
var blood_scene: PackedScene = preload("res://_scenes/effects/blood.tscn")
var fish_spawner: Node2D


func spawn_default_effect(default_effect: DEFAULT_EFFECTS, target_pos: Vector2, need_flip: bool = false):
	var packed_effect
	match default_effect:
		DEFAULT_EFFECTS.BLOOD:
			packed_effect = blood_scene
	var effect_instance = blood_scene.instantiate()
	get_tree().current_scene.add_child(effect_instance)
	effect_instance.global_position = target_pos
	if need_flip:
		for child in effect_instance.get_children():
			if child is Sprite2D:
				child.flip_v = true
				effect_instance.global_position += Vector2(0, 63)
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
