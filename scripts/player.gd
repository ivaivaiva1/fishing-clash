extends CharacterBody2D
class_name Player


@onready var character_body: CharacterBody2D = self
@onready var player_movement: PlayerMovement = %PlayerMovement
@onready var collision_effect: Collision_Effect = %collision_effect
@onready var skin_handler: SkinHandler = %skin_handler
var player_name: String 
var player_color: String
var current_money: int
var current_player: int
var game_manager: GameManager
var mass: float = 10
var collision_timer: float 
var boat_size: float
#@onready var sprite: Sprite2D = %Sprite
#@onready var sprite_arrow: Sprite2D = %arrow_sprite
#@onready var sprite_bait: Sprite2D = %BaitSprite
var texture_boat2: Texture2D = load("res://artes joao/13-04-2026/barco_nana_motor_purpledress.png")
var texture_arrow2: Texture2D = load("res://artes joao/player_arrows/seta roxa.png")
var texture_bait2: Texture2D = load("res://artes joao/14.04.26/isca/isca 2 cinza rosa.png")
@onready var col: CollisionShape2D = %CollisionShape2D
@onready var players_head: Marker2D = %players_head


func _ready() -> void:
	boat_size = col.shape.size.x
	skin_handler.set_skins(current_player)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("bait")):
		var bait: Bait = area.get_parent()
		if(bait.points == 0): return
		EffectSpawner.points_label(bait.points, players_head.global_position, self)
		add_points(bait.points)
		bait.reset()


func add_points(value: int):
	current_money += value
	
	print("add points")
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
	if global_position.y != 90.849:
		global_position.y = 90.849
	if collision_timer > 0:
		collision_timer -= delta


func send_collision_data(other_player: Player):
	var other_mass: float = other_player.mass
	var other_velocity: Vector2 = other_player.player_movement.last_velocity
	if other_player == null || other_mass == null || other_velocity == null: return
	KnockbackManager.do_collision(self, mass, player_movement.last_velocity, other_player, other_player.mass, other_player.player_movement.last_velocity)
	collision_effect.get_collision()
	other_player.collision_effect.get_collision()


func _physics_process(_delta: float) -> void:
	if collision_timer > 0: return
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		
		if other.is_in_group("player"):
			
			var other_clone: BoatClone = null
			
			for child in other.get_children():
				if child is BoatClone:
					other_clone = child
					break
			
			if other_clone != null:
				send_collision_data(other_clone.clone_father)
			else:
				var other_player: Player = other as Player
				send_collision_data(other_player)
