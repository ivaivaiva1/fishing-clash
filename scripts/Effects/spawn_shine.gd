extends Node2D

var sea_shine_scene: PackedScene = preload("uid://b6vt7djfc3x8c")
var min_shine_time: float = 1
var max_shine_time: float = 10
@onready var time_to_spawn: float = randf_range(min_shine_time, max_shine_time)
@onready var time_to_spawn2: float = randf_range(min_shine_time, max_shine_time)
@onready var time_to_spawn3: float = randf_range(min_shine_time, max_shine_time)
@onready var time_to_spawn4: float = randf_range(min_shine_time, max_shine_time)
@onready var time_to_spawn5: float = randf_range(min_shine_time, max_shine_time)
@onready var time_to_spawn6: float = randf_range(min_shine_time, max_shine_time)
@onready var time_to_spawn7: float = randf_range(min_shine_time, max_shine_time)



func  _ready() -> void:
	randomize()
	spawn_shine()
	await get_tree().create_timer(randf_range(0.1, 0.3)).timeout 
	spawn_shine()
	await get_tree().create_timer(randf_range(0.1, 0.3)).timeout 
	spawn_shine()
	await get_tree().create_timer(randf_range(0.1, 0.3)).timeout 
	spawn_shine()




func _process(delta: float) -> void:
	time_to_spawn -= delta
	if time_to_spawn < 0:
		spawn_shine()
		time_to_spawn = randf_range(min_shine_time, max_shine_time)
	
	time_to_spawn2 -= delta
	if time_to_spawn2 < 0:
		spawn_shine()
		time_to_spawn2 = randf_range(min_shine_time, max_shine_time)
	
	time_to_spawn3 -= delta
	if time_to_spawn3 < 0:
		spawn_shine()
		time_to_spawn3 = randf_range(min_shine_time, max_shine_time)
	
	time_to_spawn4 -= delta
	if time_to_spawn4 < 0:
		spawn_shine()
		time_to_spawn4 = randf_range(min_shine_time, max_shine_time)
	
	time_to_spawn5 -= delta
	if time_to_spawn5 < 0:
		spawn_shine()
		time_to_spawn5 = randf_range(min_shine_time, max_shine_time)
	
	time_to_spawn6 -= delta
	if time_to_spawn6 < 0:
		spawn_shine()
		time_to_spawn6 = randf_range(min_shine_time, max_shine_time)
	
	time_to_spawn7 -= delta
	if time_to_spawn7 < 0:
		spawn_shine()
		time_to_spawn7 = randf_range(min_shine_time, max_shine_time)



func spawn_shine():
	var target_pos = get_pos()
	var sea_shine_instance = sea_shine_scene.instantiate()
	get_tree().current_scene.add_child.call_deferred(sea_shine_instance)
	sea_shine_instance.global_position = target_pos
	var sea_shine: SeaShine = sea_shine_instance as SeaShine
	sea_shine.start()



var shines_in_rect1: int = 0
var shines_in_rect2: int = 0
var shines_in_rect3: int = 0
var shines_in_rect4: int = 0
var rect1_x_range := Vector2(3, 269.5)
var rect1_y_range := Vector2(153, 316)
var rect2_x_range := Vector2(269.5, 536)
var rect2_y_range := Vector2(153, 316)
var rect3_x_range := Vector2(3, 269.5)
var rect3_y_range := Vector2(316, 479)
var rect4_x_range := Vector2(269.5, 536)
var rect4_y_range := Vector2(316, 479)
func get_pos() -> Vector2:
	var shines = [
		shines_in_rect1,
		shines_in_rect2,
		shines_in_rect3,
		shines_in_rect4
	]
	
	var min_shines = shines.min()
	var max_shines = shines.max()
	
	var rect: int
	
	if max_shines - min_shines >= 3:
		rect = shines.find(min_shines) + 1
	else:
		rect = randi_range(1, 4)
	
	match rect:
		1:
			shines_in_rect1 += 1
			return Vector2(
				randf_range(rect1_x_range.x, rect1_x_range.y),
				randf_range(rect1_y_range.x, rect1_y_range.y)
			)
		2:
			shines_in_rect2 += 1
			return Vector2(
				randf_range(rect2_x_range.x, rect2_x_range.y),
				randf_range(rect2_y_range.x, rect2_y_range.y)
			)
		3:
			shines_in_rect3 += 1
			return Vector2(
				randf_range(rect3_x_range.x, rect3_x_range.y),
				randf_range(rect3_y_range.x, rect3_y_range.y)
			)
		4:
			shines_in_rect4 += 1
			return Vector2(
				randf_range(rect4_x_range.x, rect4_x_range.y),
				randf_range(rect4_y_range.x, rect4_y_range.y)
			)
	return Vector2.ZERO
