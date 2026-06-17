extends Node2D

@onready var game_manager: GameManager = %Game_Manager

var coin_madness_cooldown: float = 40
var coin_madness_timer: float

var cegonhas_cooldown: float = 40
var cegonhas_timer: float



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("treasure"):
		start_cegonhas()
	
	
	if coin_madness_timer > 0:
		coin_madness_timer -= delta
	else:
		game_manager.coin_madness_enabled = false
	
	if cegonhas_timer > 0:
		cegonhas_timer -= delta
	else:
		game_manager.cegonnhas_enabled = false





func start_coin_madness():
	coin_madness_timer = coin_madness_cooldown
	game_manager.coin_madness_enabled = true

func start_cegonhas():
	cegonhas_timer = cegonhas_cooldown
	game_manager.cegonnhas_enabled = true
