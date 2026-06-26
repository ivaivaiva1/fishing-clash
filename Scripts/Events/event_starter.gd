extends Node2D

@onready var fish_spawner: FishSpawner = %Fish_Spawner
@onready var spawn_treasure: SpawnTreasure = %SpawnTreasure
@onready var cegonha_spawner: CegonhasSpawner = %CegonhaSpawner


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start_event"):
		start_event()


func start_event():
	#var event_index: EVENTS_LIST = [EVENTS_LIST.RED_RAIN, EVENTS_LIST.SHINY_RAIN, EVENTS_LIST.BIG_TREASURE, EVENTS_LIST.CEGONHAS].pick_random()
	var event_index: int = EVENTS_LIST.values().pick_random()
	event_index = 4
	match event_index:
		0:
			fish_spawner.do_red_rain()
		1:
			fish_spawner.do_shiny_rain()
		2:
			spawn_treasure.spawn_treasure()
		3:
			cegonha_spawner.do_cegonhas()
		4:
			fish_spawner.spawn_chest_fish()
		null:
			print("sem evento")




enum EVENTS_LIST{
	RED_RAIN,
	SHINY_RAIN,
	BIG_TREASURE,
	CEGONHAS,
	CHEST_FISH
}
