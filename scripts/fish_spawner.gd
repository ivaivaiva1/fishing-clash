extends Node2D
class_name FishSpawner

var spawned_fish: Array[Node2D] = []

@export var blue_fish: PackedScene
@export var red_fish: PackedScene
@export var big_fish: PackedScene
var big_fish_rate: int
var red_fish_rate: int
var spawn_pos_y: Array[float] = [210.0, 442.0]
var spawn_cooldown: float
@onready var spawn_timer: float

func _ready():
	randomize()
	spawn_timer = spawn_cooldown
	#spawn_fish()

func _process(delta):
	if(spawn_timer > 0):
		spawn_timer -= delta
	else:
		spawn_timer = randf_range(spawn_cooldown * 0.84, spawn_cooldown * 0.16)
		spawn_fish()


func spawn_fish():
	# Decide qual peixe vai spawnar
	var is_big_fish 
	if(randi() % big_fish_rate == 0):
		is_big_fish = true
	else:
		is_big_fish = false
	
	
	var posX
	var move_right
	if(randi() % 2 == 0):
		posX = -50
		move_right = true
	else:
		posX = 550
		move_right = false
	
	
	var maxY = spawn_pos_y[1]
	if(is_big_fish): maxY = 410
	var posY = randf_range(spawn_pos_y[0], maxY)
	
	
	var fish_instance
	if(is_big_fish):
		fish_instance = big_fish.instantiate()
	else:
		if(randi() % red_fish_rate == 0):
			fish_instance = red_fish.instantiate()
		else:
			fish_instance = blue_fish.instantiate()
	
	
	fish_instance.move_right = move_right
	fish_instance.global_position = Vector2(posX, posY)
	add_child(fish_instance)
	spawned_fish.append(fish_instance)


func remove_all_fish():
	for fish in spawned_fish:
		if is_instance_valid(fish):
			fish.queue_free()
	spawned_fish.clear()
