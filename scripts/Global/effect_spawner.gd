extends Node

var fish_spawner: Node2D

var effect_scene: PackedScene = preload("uid://dymjc3rwm5np6")
var collision_effect_scene: PackedScene = preload("uid://bg645xjsyvikf")
var bubble_scene: PackedScene = preload("res://_scenes/effects/bubble.tscn")
var collected_coin_scene: PackedScene = preload("res://_scenes/effects/collected_coin.tscn")
var blood_scene: PackedScene = preload("res://_scenes/effects/blood.tscn")
var points_label_scene: PackedScene = preload("res://_scenes/effects/points_label.tscn")




func spawn_blood(shark: Shark, is_blood: bool, target_pos: Vector2, flip_h: bool, flip_v: bool):
	var blood_instance = blood_scene.instantiate()
	shark.add_child(blood_instance)
	blood_instance.global_position = target_pos
	if flip_v || flip_h:
		for child in blood_instance.get_children():
			if child is Sprite2D:
				child.flip_h = flip_h
				child.flip_v = flip_v
				break
	var blood_effect: BloodEffect = blood_instance as BloodEffect
	blood_effect.start(is_blood)


func spawn_effect(target_pos: Vector2, target_scale: float):
	var effect = effect_scene.instantiate()
	get_tree().current_scene.add_child(effect)
	# define a posição
	effect.global_position = target_pos
	effect.scale = Vector2(target_scale, target_scale)
	
	# adiciona na cena (usa o root atual)


func collision_effect(target_pos: Vector2):
	var effect = collision_effect_scene.instantiate()
	get_tree().current_scene.add_child(effect)
	# define a posição
	effect.global_position = target_pos



func spawn_bubble(target_pos: Vector2, target_scale: float, target_ordering: int):
	var effect = bubble_scene.instantiate()
	
	
	fish_spawner.add_child(effect)
	effect.scale = Vector2(target_scale, target_scale)
	effect.global_position = target_pos
	effect.z_index = target_ordering
	#var sprite = effect.get_node("Sprite")
	#sprite.z_index = target_ordering 


func collect_coin_effect(target_pos: Vector2):
	var effect = collected_coin_scene.instantiate()
	fish_spawner.add_child(effect)
	effect.global_position = target_pos


func points_label(label_value: int, target_pos: Vector2, target_father: Node2D = null):
	var effect = points_label_scene.instantiate()
	if target_father == null: target_father = get_tree().current_scene
	target_father.add_child(effect)
	
	if target_pos.y > 476.613: target_pos.y = 476.613
	if target_pos.x < 9.796: target_pos.x = 9.796
	if target_pos.x > 531.772: target_pos.x = 531.772
	effect.global_position = target_pos
	
	var label = effect as PointsLabel
	label.start(label_value)
