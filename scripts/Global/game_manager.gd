extends Node
class_name GameManager

var game_state: String = "menu"
@onready var FishSpawner_intance: FishSpawner = %Fish_Spawner
@onready var Shark: Shark = %shark
@onready var press_to_play: Label = %press_to_play
@export var player_scene: PackedScene
var player1: Player
var player2: Player

@onready var placar: Label = %PLACAR
@onready var money_1_label: Label = %player1_money
@onready var money_2_label: Label = %player2_money
@export var peso_1: Label 
@export var peso_2: Label 
@onready var price_flutuation: PriceFlutuation = %PriceFlutuation
@onready var clone_boats: CloneBoats = %CloneBoats
@onready var duration_bar: ProgressBar = %ProgressBar
#var round_duration: float = 240
var round_duration: float = 240
var game_timer: float = 0
var _time_accumulator: float = 0.0
@onready var treasure_scene: PackedScene = load("res://scenes/treasure.tscn")


func _ready() -> void:
	GlobalVars.GameManager_intance = self
	KnockbackManager.game_manager = self
	clone_boats.game_manager = self
	FishSpawner_intance.spawn_cooldown = GlobalVars.spawn_cooldown_menu
	FishSpawner_intance.big_fish_rate = GlobalVars.big_fish_rate_menu
	FishSpawner_intance.red_fish_rate = GlobalVars.red_fish_rate_menu
	duration_bar.max_value = round_duration
	duration_bar.value = round_duration - game_timer
	EffectSpawner.fish_spawner = FishSpawner_intance
	att_score()
	start_game()


func _process(delta: float) -> void:
	peso_1.text = "peso: " + str(GlobalVars.player1_peso)
	peso_2.text = "peso: " + str(GlobalVars.player2_peso)
	if game_state == "game":
		game_timer += delta
	
	
	duration_bar.value = round_duration - game_timer
	if game_timer > round_duration: 
		finish_round()
	
	if Input.is_action_just_pressed("treasure"):
		spawn_treasure()

func finish_round():
	if game_state != "game": return
	print("player 1 money: ", GlobalVars.player1_money)
	print("player 2 money: ", GlobalVars.player2_money)
	if GlobalVars.player1_money == GlobalVars.player2_money:
		GlobalVars.player1_score += 1
		GlobalVars.player2_score += 1
		print("anyone wins")
	elif GlobalVars.player1_money > GlobalVars.player2_money:
		GlobalVars.player1_score += 1
		print("player 1 wins")
	else:
		GlobalVars.player2_score += 1
		print("player 2 wins")
	get_tree().reload_current_scene()



func _input(event):
	if event.is_action_pressed("ui_accept"): # "ui_accept" é a tecla espaço por padrão
		start_game()



func start_game():
	if game_state == "game": return
	game_state = "game"
	GlobalVars.player1_money = 0
	GlobalVars.player2_money = 0
	
	FishSpawner_intance.remove_all_fish()
	Shark.re_start()
	press_to_play.visible = false
	money_1_label.visible = true
	money_2_label.visible = true
		#peso_1.visible = true
		#peso_2.visible = true
	
	
	var player_instance_2 = player_scene.instantiate()
	var player2: Player = player_instance_2
	player2.player_name = "player2"
	player2.current_player = 2
	player2.game_manager = self
	add_child(player_instance_2)
	player_instance_2.global_position = Vector2(353.0, 79)
	
	
	
	var player_instance_1 = player_scene.instantiate()
	var player1: Player = player_instance_1
	player1.player_name = "player1"
	player1.current_player = 1
	player1.game_manager = self
	add_child(player_instance_1)
	player_instance_1.global_position = Vector2(150, 79)
	
	
	
	
	
	FishSpawner_intance.spawn_cooldown = GlobalVars.spawn_cooldown_game
	FishSpawner_intance.big_fish_rate = GlobalVars.big_fish_rate_game
	FishSpawner_intance.red_fish_rate = GlobalVars.red_fish_rate_game



func att_money():
	money_1_label.text = str("$ "+str(GlobalVars.player1_money))
	money_2_label.text = str("$ "+str(GlobalVars.player2_money))


func att_score():
	placar.text = str(GlobalVars.player1_score , "           " , GlobalVars.player2_score)


func spawn_treasure():
	var treasure = treasure_scene.instantiate()
	FishSpawner_intance.add_child(treasure)
