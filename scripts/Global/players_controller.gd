extends Node

var joined_players: Array[JoinedPlayer] = []
 


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("backspace"):
		print_players_data()




class JoinedPlayer:
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



func new_player(player_id: int, left: String, right: String, up: String, down: String, act: String):
	var new_player = JoinedPlayer.new()
	new_player.setup(player_id, left, right, up, down, act)
	joined_players.append(new_player)


func remove_player(player_id: int):
	for i in range(joined_players.size()):
		if joined_players[i].id == player_id:
			joined_players.remove_at(i)
			return



func print_players_data():
	if joined_players.is_empty():
		print("Nenhum player ativo")
		return
	
	print("=== PLAYERS ATIVOS ===")
	
	for p in joined_players:
		print("ID:", p.id)
		print(" Left:", p.move_left)
		print(" Right:", p.move_right)
		print(" Up:", p.move_up)
		print(" Down:", p.move_down)
		print(" Action:", p.action)
		print("--------------------")
