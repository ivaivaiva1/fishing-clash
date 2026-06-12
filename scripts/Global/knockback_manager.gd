extends Node

var game_manager: GameManager
var player1: Player
var player2: Player
var player3: Player
var player4: Player
var timer: float 

func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta


var knockback_impact: float = 1.0


func do_collision(col1_player: Player, _col1_mass: float, col1_velocity: Vector2, col2_player: Player , _col2_mass: float, col2_velocity: Vector2):
	if timer > 0: return
	timer = 0.3
	print("PROCESS COLISION")
	
	var collision_normal = (col2_player.global_position - col1_player.global_position).normalized()
	var relative_velocity = col1_velocity - col2_velocity
	
	var impact_strength = relative_velocity.dot(collision_normal)
	
	## Se não há impacto real
	#if impact_strength <= 0:
		#actual_collision = CollisionData.new()
		#return
	
	var impulse = collision_normal * (impact_strength + 20) * knockback_impact
	
	
	col1_player.velocity -= impulse
	col2_player.velocity += impulse
	col1_player.player_movement.last_velocity -= impulse
	col2_player.player_movement.last_velocity += impulse
	
	EffectSpawner.collision_effect(col1_player.global_position)
	print("Impact strength:", impact_strength)



func get_player_data():
	player1 = game_manager.player1
	player2 = game_manager.player2
	player3 = game_manager.player3
	player4 = game_manager.player4
