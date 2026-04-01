extends Node2D
class_name CloneBoats

var game_manager: GameManager
var player1: Player
var player2: Player
@onready var clone1: Node2D = %BOAT1_CLONE
@onready var clone2: Node2D = %BOAT2_CLONE

var screen_size: float = 540
var boat1_size: float
var boat2_size: float




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player1 == null || player2 == null:
		get_player_data()
		return
	
	check_player1()
	check_player2()
	player1_warp()
	player2_warp()

func player1_warp():
	var half_boatSize = boat1_size / 2
	if player1.global_position.x < -half_boatSize:
		clone1.global_position.x = -1000
		player1.global_position.x = 540 + half_boatSize
	elif player1.global_position.x > screen_size + half_boatSize:
		clone1.global_position.x = -1000
		player1.global_position.x = -half_boatSize

func player2_warp():
	var half_boatSize = boat2_size / 2
	if player2.global_position.x < -half_boatSize:
		clone2.global_position.x = -1000
		player2.global_position.x = 540 + half_boatSize
	elif player2.global_position.x > screen_size + half_boatSize:
		clone2.global_position.x = -1000
		player2.global_position.x = -half_boatSize

func check_player1():
	var out_pixels: float
	var out_side: String
	var half_boatSize = boat1_size / 2
	
	# saiu pela esquerda
	if player1.global_position.x - half_boatSize < 0:
		out_side = "Left"
		out_pixels = abs(player1.global_position.x - half_boatSize)
		#print("Player 1 saiu", out_pixels, "pixels pela esquerda")
	# saiu pela direita
	elif player1.global_position.x + half_boatSize > screen_size:
		out_side = "Right"
		out_pixels = (player1.global_position.x + half_boatSize) - screen_size
		#print("Player 1 saiu", out_pixels, "pixels pela direita")
	
	if out_side != "":
		move_clone1(out_side, out_pixels)
	else:
		clone1.global_position.x = -1000


func move_clone1(out_side: String, out_pixels: float):
	var half_boatSize = boat1_size / 2
	
	if out_side == "Left":
		clone1.global_position.x = screen_size - half_boatSize - out_pixels + (boat1_size * 2)
	
	elif out_side == "Right":
		clone1.global_position.x = half_boatSize + out_pixels - (boat1_size * 2)


func check_player2():
	var out_pixels: float
	var out_side: String
	var half_boatSize = boat2_size / 2
	
	# saiu pela esquerda
	if player2.global_position.x - half_boatSize < 0:
		out_side = "Left"
		out_pixels = abs(player2.global_position.x - half_boatSize)
		#print("Player 2 saiu", out_pixels, "pixels pela esquerda")
	# saiu pela direita
	elif player2.global_position.x + half_boatSize > screen_size:
		out_side = "Right"
		out_pixels = (player2.global_position.x + half_boatSize) - screen_size
		#print("Player 2 saiu", out_pixels, "pixels pela direita")
	
	if out_side != "":
		move_clone2(out_side, out_pixels)
	else:
		clone2.global_position.x = -2000


func move_clone2(out_side: String, out_pixels: float):
	var half_boatSize = boat2_size / 2
	
	if out_side == "Left":
		clone2.global_position.x = screen_size - half_boatSize - out_pixels + (boat2_size * 2)
	
	elif out_side == "Right":
		clone2.global_position.x = half_boatSize + out_pixels - (boat2_size * 2)



func get_player_data():
	player1 = game_manager.player1
	player2 = game_manager.player2
	if player1 != null && player2 != null:
		boat1_size = player1.boat_size
		boat2_size = player2.boat_size
