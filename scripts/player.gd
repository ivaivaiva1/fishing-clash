extends CharacterBody2D
class_name Player

var player_name: String 
var current_score: int
var current_player: int = 0
var game_manager: GameManager

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("bait")):
		var bait: Bait = area.get_parent()
		if(bait.bait_state != "catch"): return
		current_score += bait.points * game_manager.price_flutuation.actual_price
		if(player_name == "player1"):
			GlobalVars.player1_score = current_score
		else:
			GlobalVars.player2_score = current_score
		bait.reset()
		GlobalVars.GameManager_intance.att_score()




@export var speed: float = 80.0
@export var acceleration: float = 130.0
@export var friction: float = 200.0

func _physics_process(delta):
	var direction
	if current_player == 1: direction = Input.get_axis("move_left1", "move_right1")
	else: direction = Input.get_axis("move_left2", "move_right2")
	
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	move_and_slide()
