extends Node2D

@onready var fish_spawner: FishSpawner = %Fish_Spawner
@onready var spawn_treasure: SpawnTreasure = %SpawnTreasure
@onready var cegonha_spawner: CegonhasSpawner = %CegonhaSpawner
var banished_events: Array[int] = []
@onready var spawn_event_counter: float = randf_range(20, 40)
var last_event_is_checked: bool = false

func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	if last_event_is_checked: return
	if spawn_event_counter > 0:
		spawn_event_counter -= delta
	else: 
		spawn_event_counter = 999
		spawn_event()
	
	if GlobalVars.GameManager_intance.time_left < 20:
		last_event_is_checked = true
		if spawn_event_counter < 10:
			spawn_event()
	
	#if Input.is_action_just_pressed("start_event"):
		#spawn_event()


func spawn_event():
	var sort_number:= true
	var event_index: int 
	while(sort_number):
		event_index = EVENTS_LIST.values().pick_random()
		if !banished_events.has(event_index):
			sort_number = false
	
	var big_cooldown: bool = true
	#event_index = 5
	
	match event_index:
		0:
			banished_events.append(event_index)
			fish_spawner.do_red_rain()
		1:
			fish_spawner.do_shiny_rain()
			big_cooldown = false
		2:
			spawn_treasure.spawn_treasure()
			big_cooldown = false
		3:
			cegonha_spawner.do_cegonhas()
			big_cooldown = false
		4:
			fish_spawner.spawn_chest_fish()
			big_cooldown = false
		5:
			banished_events.append(event_index)
			fish_spawner.do_pingente()
		null:
			push_error("evento invalido")
	set_event_counter(big_cooldown)


func set_event_counter(big_cooldown: bool):
	var min_cooldown: float
	var max_cooldown: float
	if big_cooldown:
		min_cooldown = 40
		max_cooldown = 60
	else:
		min_cooldown = 20
		max_cooldown = 35
	spawn_event_counter = randf_range(min_cooldown, max_cooldown)


enum EVENTS_LIST{
	RED_RAIN,
	SHINY_RAIN,
	BIG_TREASURE,
	CEGONHAS,
	CHEST_FISH,
	PINGENTE
}
