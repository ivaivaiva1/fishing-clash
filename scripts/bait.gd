extends CharacterBody2D
class_name Bait

var input_action := ""
var player_name
@export var blue_fish_list: Array[Node2D] 
@export var red_fish_list: Array[Node2D] 
@export var golden_fish_list: Array[Node2D]
var bait_state: String = "free"
var points = 0
var has_blue_fishs = 0
var has_red_fishs = 0
var has_golden_fishs = 0

func _ready() -> void:
	var player: Player = get_parent()
	player_name = player.player_name
	input_action = player.player_name



const SWIM_FORCE = 500.0
const MAX_SPEED = 100
const ACCELERATION = 300
var actual_boost: float
const boost_force = 20
const boost_time = 0.2
var peso = 1
@onready var boost_controller: BoostController = %boost_controller


func _physics_process(delta):
	var target_velocity_y = 0.0
	
	if Input.is_action_just_pressed(input_action):
		boost_controller.do_boost()
		pass
	
	
	if Input.is_action_pressed(input_action) || actual_boost > 0:
		# Jogador segurando o botão: subir
		target_velocity_y = -(MAX_SPEED * 1.3) / peso
	else:
		# Jogador não segurando: descer
		if(bait_state == "free"):
			target_velocity_y = MAX_SPEED * 0.8
		else:
			target_velocity_y = MAX_SPEED * 0.8
	
	var adjusted_boost = actual_boost / (peso / 2)
	if(actual_boost > 0): target_velocity_y -= adjusted_boost
	
	
	# Ajusta suavemente a velocidade atual em direção àvelocidade alvo
	velocity.y = move_toward(velocity.y, target_velocity_y, ACCELERATION * delta)
	
	move_and_slide()



func get_fish(fish_name: String, fish_peso: float, fish_points: int) -> void:
	bait_state = "catch"
	peso += fish_peso 
	points += fish_points
	if(player_name == "player1"):
		GlobalVars.player1_peso = peso
	else:
		GlobalVars.player2_peso = peso
	
	update_fishs(fish_name)


func update_fishs(fish_name: String):
	match fish_name:
		"blue":
			has_blue_fishs += 1
			if(blue_fish_list.size() < has_blue_fishs): return
			blue_fish_list[has_blue_fishs - 1].visible = true
		"red":
			has_red_fishs += 1
			if(red_fish_list.size() < has_red_fishs): return
			red_fish_list[has_red_fishs - 1].visible = true
		"golden":
			has_golden_fishs += 1
			if(golden_fish_list.size() < has_golden_fishs): return
			golden_fish_list[has_golden_fishs - 1].visible = true
		_:
			pass

func reset_fishs():
	for fish in blue_fish_list:
		fish.visible = false
	for fish in red_fish_list:
		fish.visible = false
	for fish in golden_fish_list:
		fish.visible = false
	has_blue_fishs = 0
	has_red_fishs = 0
	has_golden_fishs = 0

func reset():
	bait_state = "free"
	peso = 1
	points = 0
	reset_fishs()
