extends Node2D
class_name CloneBoats

var game_manager: GameManager

var players: Array = []
var clones: Array = []
var boat_sizes: Array = []
var number_of_players: int = 4

var screen_size: float = 540

@onready var clone1: BoatClone = %BOAT1_CLONE
@onready var clone2: BoatClone = %BOAT2_CLONE
@onready var clone3: BoatClone = %BOAT3_CLONE
@onready var clone4: BoatClone = %BOAT4_CLONE


func _ready():
	clones = [clone1, clone2, clone3, clone4]
	populate_scripts()


func populate_scripts():
	var possible_players = [
		game_manager.player1,
		game_manager.player2,
		game_manager.player3,
		game_manager.player4
	]
	
	for i in range(clones.size()):
		if i < number_of_players and possible_players[i] != null:
			clones[i].clone_father = possible_players[i]
		else:
			clones[i].clone_father = null
			clones[i].global_position.x = -1000


func _process(delta: float) -> void:
	get_player_data()
	
	for i in range(min(number_of_players, players.size(), clones.size())):
		check_player(i)
		player_warp(i)


func player_warp(i: int):
	var player = players[i]
	var clone = clones[i]
	var boat_size = boat_sizes[i]
	
	var half_boatSize = boat_size / 2
	
	if player.global_position.x < -half_boatSize:
		clone.global_position.x = -1000
		player.global_position.x = screen_size + half_boatSize
	
	elif player.global_position.x > screen_size + half_boatSize:
		clone.global_position.x = -1000
		player.global_position.x = -half_boatSize


func check_player(i: int):
	var player = players[i]
	var clone = clones[i]
	var boat_size = boat_sizes[i]
	
	var out_pixels: float = 0
	var out_side: String = ""
	var half_boatSize = boat_size / 2
	
	if player.global_position.x - half_boatSize < 0:
		out_side = "Left"
		out_pixels = abs(player.global_position.x - half_boatSize)
	
	elif player.global_position.x + half_boatSize > screen_size:
		out_side = "Right"
		out_pixels = (player.global_position.x + half_boatSize) - screen_size
	
	if out_side != "":
		move_clone(i, out_side, out_pixels)
	else:
		clone.global_position.x = -1000 * ((i + 1) * 5)


func move_clone(i: int, out_side: String, out_pixels: float):
	var clone = clones[i]
	var boat_size = boat_sizes[i]
	var half_boatSize = boat_size / 2
	
	if out_side == "Left":
		clone.global_position.x = screen_size - half_boatSize - out_pixels + (boat_size * 2)
	
	elif out_side == "Right":
		clone.global_position.x = half_boatSize + out_pixels - (boat_size * 2)


func get_player_data():
	players.clear()
	boat_sizes.clear()
	
	var possible_players = [
		game_manager.player1,
		game_manager.player2,
		game_manager.player3,
		game_manager.player4
	]
	
	for i in range(number_of_players):
		var p = possible_players[i]
		
		if p != null:
			players.append(p)
			boat_sizes.append(p.boat_size)
