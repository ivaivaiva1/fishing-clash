extends Node
class_name GameManager

var game_state: String = "menu"
@onready var FishSpawner_intance: FishSpawner = %Fish_Spawner
@onready var Shark: Shark = %shark
@onready var press_to_play: Label = %press_to_play
@export var player_scene: PackedScene
@onready var score_1: Label = %score_player_1
@onready var score_2: Label = %score_player_2
@export var peso_1: Label 
@export var peso_2: Label 

func _ready() -> void:
	GlobalVars.GameManager_intance = self
	FishSpawner_intance.spawn_cooldown = GlobalVars.spawn_cooldown_menu
	FishSpawner_intance.big_fish_rate = GlobalVars.big_fish_rate_menu
	FishSpawner_intance.red_fish_rate = GlobalVars.red_fish_rate_menu

func _process(delta: float) -> void:
	peso_1.text = "peso: " + str(GlobalVars.player1_peso)
	peso_2.text = "peso: " + str(GlobalVars.player2_peso)
	#print("peso 1: ", str(GlobalVars.player1_score))
	#print("peso 2: ", str(GlobalVars.player2_score))

func _input(event):
	if event.is_action_pressed("ui_accept"): # "ui_accept" é a tecla espaço por padrão
		game_state = "game"
		FishSpawner_intance.remove_all_fish()
		Shark.re_start()
		press_to_play.visible = false
		score_1.visible = true
		score_2.visible = true
		peso_1.visible = true
		peso_2.visible = true
		
		var player_instance_1 = player_scene.instantiate()
		var player1: Player = player_instance_1
		player1.player_name = "player1"
		add_child(player_instance_1)
		player_instance_1.global_position = Vector2(150, 107)
		
		
		var player_instance_2 = player_scene.instantiate()
		var player2: Player = player_instance_2
		player2.player_name = "player2"
		add_child(player_instance_2)
		player_instance_2.global_position = Vector2(353.0, 107)
		
		
		FishSpawner_intance.spawn_cooldown = GlobalVars.spawn_cooldown_game
		FishSpawner_intance.big_fish_rate = GlobalVars.big_fish_rate_game
		FishSpawner_intance.red_fish_rate = GlobalVars.red_fish_rate_game

func att_score():
	score_1.text = str(GlobalVars.player1_score)
	score_2.text = str(GlobalVars.player2_score)
	if(GlobalVars.player1_score > 1500): get_tree().paused = true
	if(GlobalVars.player2_score > 1500): get_tree().paused = true
