extends Node

var game_manager: GameManager
var player1: Player
var player2: Player
var timer: float 

func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta


var knockback_impact: float = 1.0


func do_collision(player1_mass: float, player2_mass: float, player1_velocity: Vector2, player2_velocity: Vector2):
	if timer > 0: return
	timer = 0.3
	print("PROCESS COLISION")
	if player1 == null || player2 == null:
		get_player_data()
	
	
	var v1 = player1_velocity
	var v2 = player2_velocity
	
	var collision_normal = (player2.global_position - player1.global_position).normalized()
	var relative_velocity = v1 - v2
	
	var impact_strength = relative_velocity.dot(collision_normal)
	
	## Se não há impacto real
	#if impact_strength <= 0:
		#actual_collision = CollisionData.new()
		#return
	
	var impulse = collision_normal * impact_strength * knockback_impact
	
	
	player1.velocity -= impulse
	player2.velocity += impulse
	
	
	print("Impact strength:", impact_strength)



func get_player_data():
	player1 = game_manager.player1
	player2 = game_manager.player2
