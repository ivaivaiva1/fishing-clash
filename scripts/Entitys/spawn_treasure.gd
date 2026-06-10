extends Node2D
class_name SpawnTreasure

@onready var game_manager: GameManager = GlobalVars.GameManager_intance
var spawned_treasures: int = 0
var time_since_spawn: float
var alive_treasures: Array[Treasure] 
var treasure_container_scene: PackedScene = preload("uid://bdt27v65wmvui")
var min_treasure_time: float = 45
var max_treasure_time: float = 120
@onready var time_to_spawn: float = randf_range(10, max_treasure_time)




func _process(delta: float) -> void:
	print(time_to_spawn)
	time_since_spawn += delta
	time_to_spawn -= delta
	if time_to_spawn < 0:
		spawn_treasure()
		time_to_spawn = randf_range(min_treasure_time, max_treasure_time)
	
	if game_manager.round_duration - game_manager.game_timer < 30:
		if spawned_treasures < 2:
			spawn_treasure()
			time_to_spawn = 1000
			time_since_spawn = -1000
		elif time_since_spawn > min_treasure_time:
			spawn_treasure()
		else:
			time_to_spawn = 1000
			time_since_spawn = -1000
	
	
	
	if Input.is_action_just_pressed("treasure"):
		spawn_treasure()



func spawn_treasure():
	time_since_spawn = 0
	spawned_treasures += 1
	var target_posX = get_posX()
	var treasure_instance = treasure_container_scene.instantiate()
	get_tree().current_scene.add_child(treasure_instance)
	treasure_instance.global_position.x = target_posX
	treasure_instance.global_position.y = 900
	
	
	for child in treasure_instance.get_children():
		if child is Treasure:
			var child_treasure: Treasure = child as Treasure
			child_treasure.spawn_treasure = self as SpawnTreasure
			alive_treasures.append(child_treasure)
			break


var min_x: float = 35.0
var max_x: float = 505.0
var min_distance: float = 70.0
func get_posX() -> float:
	if alive_treasures.is_empty():
		return get_viewport().get_camera_2d().get_screen_center_position().x
	
	var max_attempts := 100
	
	for i in range(max_attempts):
		var candidate_x = randf_range(min_x, max_x)
		var valid := true
		
		for treasure in alive_treasures:
			if abs(candidate_x - treasure.global_position.x) < min_distance:
				valid = false
				break
		
		if valid:
			return candidate_x
	
	# Fallback caso não encontre posição válida
	return randf_range(min_x, max_x)


func treasure_caught(treasure: Treasure):
	alive_treasures.erase(treasure)
