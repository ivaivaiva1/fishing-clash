extends Node2D
class_name FishSpawner

var spawned_fish: Array[Node2D] = []
var chest_fish: PackedScene = preload("uid://pj5f4o6fc50o")

@export var blue_fish: PackedScene
@export var red_fish: PackedScene
@export var big_fish: PackedScene
var big_fish_rate: int
var red_fish_rate: int
var shrimp_fish_rate: int
var spawn_pos_y: Array[float] = [205.0, 500.0]
var spawn_cooldown: float
@onready var spawn_timer: float


func _ready():
	randomize()
	spawn_timer = spawn_cooldown


func _process(delta):
	red_rain_counter(delta)
	shiny_rain_counter(delta)
	pingente_counter(delta)
	spawn_fish_counter(delta)


func spawn_fish_counter(delta: float):
	if(spawn_timer > 0):
		spawn_timer -= delta
	else:
		if red_rain: spawn_timer = randf_range((spawn_cooldown/3.5) * 0.84, (spawn_cooldown/3.5) * 0.16)
		else: spawn_timer = randf_range(spawn_cooldown * 0.84, spawn_cooldown * 0.16)
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
		posX = -100
		move_right = true
	else:
		posX = 600
		move_right = false
	
	
	var maxY = spawn_pos_y[1]
	if(is_big_fish): maxY = 460
	var posY = randf_range(spawn_pos_y[0], maxY)
	
	
	var fish_instance
	if red_rain && randf() <= 0.9:
		fish_instance = red_fish.instantiate()
	elif is_big_fish:
		fish_instance = big_fish.instantiate()
	else:
		if(randi() % red_fish_rate == 0):
			fish_instance = red_fish.instantiate()
		else:
			fish_instance = blue_fish.instantiate()
	
	
	fish_instance.move_right = move_right
	fish_instance.global_position = Vector2(posX, posY)
	if shiny_rain: fish_instance.shiny_rain = true
	if pingente: fish_instance.pingente_rain = true
	add_child(fish_instance)
	spawned_fish.append(fish_instance)


func spawn_chest_fish():
	var chest_fish := chest_fish.instantiate()
	add_child(chest_fish)


func shiny_all_fish():
	for fish in spawned_fish:
		if is_instance_valid(fish):
			fish.make_shiny()



var red_rain: bool = false
var red_rain_duration: float = 40
var red_rain_timer: float 
func do_red_rain():
	if red_rain: return
	red_rain = true
	red_rain_timer = red_rain_duration
func red_rain_counter(delta: float):
	if red_rain:
		red_rain_timer -= delta
		if red_rain_timer <= 0:
			red_rain = false


var shiny_rain: bool = false
var shiny_rain_duration: float = 10
var shiny_rain_timer: float 
func do_shiny_rain():
	if shiny_rain: return 
	shiny_rain = true
	shiny_rain_timer = shiny_rain_duration
	shiny_all_fish()
func shiny_rain_counter(delta: float):
	if shiny_rain:
		shiny_rain_timer -= delta
		if shiny_rain_timer <= 0:
			shiny_rain = false


var pingente: bool = false
var pingente_duration: float = 50
var pingente_timer: float
func do_pingente():
	if pingente: return
	pingente = true
	pingente_timer = pingente_duration
func pingente_counter(delta: float):
	if pingente:
		pingente_timer -= delta
		if pingente_timer <= 0:
			pingente = false
