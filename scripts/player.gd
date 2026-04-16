extends CharacterBody2D
class_name Player


@onready var character_body: CharacterBody2D = self
@onready var player_movement: PlayerMovement = %PlayerMovement
@onready var collision_effect: Collision_Effect = %collision_effect
@onready var skin_handler: SkinHandler = %skin_handler
var player_name: String 
var current_money: int
var current_player: int
var game_manager: GameManager
var mass: float = 10
var collision_timer: float 
var boat_size: float
@onready var sprite: Sprite2D = %Sprite
@onready var sprite_arrow: Sprite2D = %arrow_sprite
@onready var sprite_bait: Sprite2D = %BaitSprite
var texture_boat2: Texture2D = load("res://artes joao/13-04-2026/barco_nana_motor_purpledress.png")
var texture_arrow2: Texture2D = load("res://artes joao/player_arrows/seta roxa.png")
var texture_bait2: Texture2D = load("res://artes joao/14.04.26/isca/isca 2 cinza rosa.png")
@onready var col: CollisionShape2D = %CollisionShape2D


func _ready() -> void:
	boat_size = col.shape.size.x
	skin_handler.set_skins(current_player)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("bait")):
		var bait: Bait = area.get_parent()
		if(bait.points == 0): return
		add_points(bait.points)
		bait.reset()


func add_points(value: int):
	current_money += value
	
	if player_name == "player1":
		GlobalVars.player1_money = current_money
	elif player_name == "player2":
		GlobalVars.player2_money = current_money
	elif player_name == "player3":
		GlobalVars.player3_money = current_money
	elif player_name == "player4":
		GlobalVars.player4_money = current_money
	
	GlobalVars.GameManager_intance.att_money()


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
			var other_player: Player
			var player1_mass: float
			var player2_mass: float
			var player1_velocity: Vector2
			var player2_velocity: Vector2
			
			if current_player == 1:
				other_player = game_manager.player2
				player1_mass = mass
				player1_velocity = player_movement.last_velocity
				player2_mass = other_player.mass
				player2_velocity = other_player.player_movement.last_velocity
			else:
				other_player = game_manager.player1
				player1_mass = other_player.mass
				player1_velocity = other_player.player_movement.last_velocity
				player2_mass = mass
				player2_velocity = player_movement.last_velocity
			KnockbackManager.do_collision(player1_mass, player2_mass, player1_velocity, player2_velocity)
			collision_effect.get_collision()
			other_player.collision_effect.get_collision()
