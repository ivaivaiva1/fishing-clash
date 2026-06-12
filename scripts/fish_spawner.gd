extends Node2D
class_name FishSpawner

var spawned_fish: Array[Node2D] = []

@export var blue_fish: PackedScene
@export var red_fish: PackedScene
@export var big_fish: PackedScene
@export var shrimp: PackedScene
var big_fish_rate: int
var red_fish_rate: int
var shrimp_fish_rate: int
var spawn_pos_y: Array[float] = [205.0, 500.0]
var spawn_cooldown: float
@onready var spawn_timer: float


var red_rain: bool = false
var red_rain_duration: float = 30
var red_rain_timer: float 


func _ready():
	randomize()
	spawn_timer = spawn_cooldown
	#spawn_fish()


func _process(delta):
	if(spawn_timer > 0):
		spawn_timer -= delta
	else:
		if red_rain: spawn_timer = randf_range((spawn_cooldown/3.5) * 0.84, (spawn_cooldown/3.5) * 0.16)
		else: spawn_timer = randf_range(spawn_cooldown * 0.84, spawn_cooldown * 0.16)
		spawn_fish()
	
	# RED RAIN
	if red_rain:
		red_rain_timer -= delta
		if red_rain_timer <= 0:
			red_rain = false
	if Input.is_action_just_pressed("red_rain"):
		do_red_rain()



func spawn_fish():
	# Decide qual peixe vai spawnar
	var is_big_fish 
	var _is_shrimp
	if(randi() % big_fish_rate == 0):
		is_big_fish = true
	else:
		is_big_fish = false
		if randi() % shrimp_fish_rate == 0:
			_is_shrimp = true
	
	
	var posX
	var move_right
	if(randi() % 2 == 0):
		posX = -50
		move_right = true
	else:
		posX = 550
		move_right = false
	
	
	var maxY = spawn_pos_y[1]
	if(is_big_fish): maxY = 460
	var posY = randf_range(spawn_pos_y[0], maxY)
	
	
	var fish_instance
	if red_rain && randf() <= 0.9:
		fish_instance = red_fish.instantiate()
	elif is_big_fish:
		fish_instance = big_fish.instantiate()
	#elif is_shrimp:
		#fish_instance = shrimp.instantiate()
	else:
		if(randi() % red_fish_rate == 0):
			fish_instance = red_fish.instantiate()
		else:
			fish_instance = blue_fish.instantiate()
	
	
	fish_instance.move_right = move_right
	fish_instance.global_position = Vector2(posX, posY)
	if red_rain: fish_instance.red_rain = true
	add_child(fish_instance)
	spawned_fish.append(fish_instance)



func remove_all_fish():
	for fish in spawned_fish:
		if is_instance_valid(fish):
			fish.queue_free()
	spawned_fish.clear()


func do_red_rain():
	red_rain = true
	red_rain_timer = red_rain_duration
