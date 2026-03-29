extends CharacterBody2D
class_name Player


@onready var character_body: CharacterBody2D = self
@onready var player_movement: PlayerMovement = %PlayerMovement
var player_name: String 
var current_score: int
var current_player: int = 0
var game_manager: GameManager
var mass: float = 10
var collision_timer: float 
@onready var sprite: Sprite2D = %Sprite2


func _ready() -> void:
	if current_player == 1: game_manager.player1 = self
	if current_player == 2: game_manager.player2 = self
	if current_player == 2: 
		sprite.modulate = Color("#efff96")
		sprite.modulate.a = 100



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


func _process(delta: float) -> void:
	if collision_timer > 0:
		collision_timer -= delta


func _physics_process(delta: float) -> void:
	if collision_timer > 0: return
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		
		if other.is_in_group("player"):
			print("colidiu")
			collision_timer = 0.3
			KnockbackManager.start_collission(current_player, mass, player_movement.last_velocity)
