extends Node

var game_manager: GameManager
var player1: Player
var player2: Player
var actual_collision: CollisionData = CollisionData.new()




func start_collission(player_id: int, mass: float, impact_velocity: Vector2):
	if player_id == 1:
		actual_collision.player1_mass = mass
		actual_collision.player1_velocity = impact_velocity
		actual_collision.player1_received = true
	elif player_id == 2:
		actual_collision.player2_mass = mass
		actual_collision.player2_velocity = impact_velocity
		actual_collision.player2_received = true
	
	
	if actual_collision.is_complete():
		process_collision()



var knockback_impact: float = 1.0

func process_collision():
	if player1 == null || player2 == null:
		get_player_data()
	
	
	var v1 = actual_collision.player1_velocity
	var v2 = actual_collision.player2_velocity
	
	var collision_normal = (player2.global_position - player1.global_position).normalized()
	var relative_velocity = v1 - v2
	
	var impact_strength = relative_velocity.dot(collision_normal)
	
	# Se não há impacto real
	if impact_strength <= 0:
		actual_collision = CollisionData.new()
		return
	
	var impulse = collision_normal * impact_strength * knockback_impact
	
	
	player1.velocity -= impulse
	player2.velocity += impulse
	
	
	print("Impact strength:", impact_strength)
	
	
	actual_collision = CollisionData.new()





func get_player_data():
	player1 = game_manager.player1
	player2 = game_manager.player2



class CollisionData:
	var player1_mass: float
	var player1_velocity: Vector2
	var player1_received := false
	
	var player2_mass: float
	var player2_velocity: Vector2
	var player2_received := false
	
	func is_complete() -> bool:
		return player1_received and player2_received
