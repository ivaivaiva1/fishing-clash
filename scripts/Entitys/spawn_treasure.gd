extends Node2D

var treasure_container_scene: PackedScene = preload("uid://bdt27v65wmvui")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("treasure"):
		spawn_treasure()


func spawn_treasure():
	var treasure_instance = treasure_container_scene.instantiate()
	get_tree().current_scene.add_child(treasure_instance)
	treasure_instance.global_position.x = get_viewport().get_camera_2d().get_screen_center_position().x
	treasure_instance.global_position.y = 900
