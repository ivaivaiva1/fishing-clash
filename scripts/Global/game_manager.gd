extends Node
class_name GameManager

var game_state: String = "menu"
@onready var FishSpawner_intance: FishSpawner = %Fish_Spawner
@export var player_scene: PackedScene
var player1: Player
var player2: Player
var player3: Player
var player4: Player


@onready var player_1info: PlayerInfo = %PLAYER1INFO
@onready var player_2info: PlayerInfo = %PLAYER2INFO
@onready var player_3info: PlayerInfo = %PLAYER3INFO
@onready var player_4info: PlayerInfo = %PLAYER4INFO


@onready var game_countdown_label: Label = %game_countdown
@export var peso_1: Label 
@export var peso_2: Label 
@onready var clone_boats: CloneBoats = %CloneBoats
var round_duration: float = 240
var game_timer: float = 0


# Event Vars
var coin_madness_enabled: bool = false

# -----------------------------------


func _ready() -> void:
	GlobalVars.GameManager_intance = self
	KnockbackManager.game_manager = self
	clone_boats.game_manager = self
	FishSpawner_intance.spawn_cooldown = GlobalVars.spawn_cooldown_menu
	FishSpawner_intance.big_fish_rate = GlobalVars.big_fish_rate_menu
	FishSpawner_intance.red_fish_rate = GlobalVars.red_fish_rate_menu
	EffectSpawner.fish_spawner = FishSpawner_intance
	att_money()
	att_points()
	start_game()


func _process(delta: float) -> void:
	if game_state == "game":
		game_timer += delta
	
	var time_left: float = max(0.0, round_duration - game_timer)
	
	var minutes: int = floori(time_left / 60.0)
	var seconds: int = int(time_left) % 60
	
	game_countdown_label.text = "%01d:%02d" % [minutes, seconds]
	
	if game_timer > round_duration:
		finish_round()


func finish_round():
	if game_state != "game": return
	
	var monies = [
		GlobalVars.player1_money,
		GlobalVars.player2_money,
		GlobalVars.player3_money,
		GlobalVars.player4_money
	]
	
	var max_money = monies.max()
	
	for i in range(monies.size()):
		if monies[i] == max_money:
			match i:
				0:
					GlobalVars.player1_score += 1
					print("player 1 wins")
				1:
					GlobalVars.player2_score += 1
					print("player 2 wins")
				2:
					GlobalVars.player3_score += 1
					print("player 3 wins")
				3:
					GlobalVars.player4_score += 1
					print("player 4 wins")
	
	get_tree().reload_current_scene()



func start_game():
	if game_state == "game": return
	game_state = "game"
	spawn_players()
	
	FishSpawner_intance.spawn_cooldown = GlobalVars.spawn_cooldown_game
	FishSpawner_intance.big_fish_rate = GlobalVars.big_fish_rate_game
	FishSpawner_intance.red_fish_rate = GlobalVars.red_fish_rate_game
	#FishSpawner_intance.shrimp_fish_rate = GlobalVars.shrimp_fish_rate_game

var players_number: int = 2
func spawn_players():
	GlobalVars.player1_money = 0
	GlobalVars.player2_money = 0
	GlobalVars.player3_money = 0
	GlobalVars.player4_money = 0
	
	
	player_1info.make_active()
	var player_instance_1 = player_scene.instantiate()
	player1 = player_instance_1
	player1.player_name = "player1"
	player1.current_player = 1
	player1.game_manager = self
	add_child(player_instance_1)
	player_instance_1.global_position = Vector2(180, 90.849)
	
	player_2info.make_active()
	var player_instance_2 = player_scene.instantiate()
	player2 = player_instance_2
	player2.player_name = "player2"
	player2.current_player = 2
	player2.game_manager = self
	add_child(player_instance_2)
	player_instance_2.global_position = Vector2(353.0, 90.849)
	
	if players_number < 3: 
		player_3info.make_empty()
		player_4info.make_empty()
		return
	player_3info.visible = true
	var player_instance_3 = player_scene.instantiate()
	player3 = player_instance_3
	player3.player_name = "player3"
	player3.current_player = 3
	player3.game_manager = self
	add_child(player_instance_3)
	player_instance_3.global_position = Vector2(180, 79)
	
	if players_number < 4: 
		player_4info.make_empty()
		return
	player_4info.visible = true
	var player_instance_4 = player_scene.instantiate()
	player4 = player_instance_4
	player4.player_name = "player4"
	player4.current_player = 4
	player4.game_manager = self
	add_child(player_instance_4)
	player_instance_4.global_position = Vector2(450, 79)


func att_money():
	player_1info.att_money_label(GlobalVars.player1_money)
	player_2info.att_money_label(GlobalVars.player2_money)
	player_3info.att_money_label(GlobalVars.player3_money)
	player_4info.att_money_label(GlobalVars.player4_money)


func att_points():
	player_1info.att_points_label(GlobalVars.player1_score)
	player_2info.att_points_label(GlobalVars.player2_score)
	player_3info.att_points_label(GlobalVars.player3_score)
	player_4info.att_points_label(GlobalVars.player4_score)
