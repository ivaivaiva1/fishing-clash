extends Node

var alive_players: Array[AlivePlayer] = []
 

class AlivePlayer:
	var id: int
	var move_left: String
	var move_right: String
	var move_up: String
	var move_down: String
	var action: String
	
	func setup(player_id: int, left: String, right: String, up: String, down: String, act: String):
		id = player_id
		move_left = left
		move_right = right
		move_up = up
		move_down = down
		action = act
