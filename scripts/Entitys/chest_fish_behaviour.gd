extends Node2D

var already_purge: bool = false
@onready var chest_fish_behaviour: Node2D = $"."
@onready var chest_fish: Fish = get_parent() as Fish

var move_right: bool
var initial_speed: float
var is_started: bool

var target_velocity: float
var actual_velocity: float

var acceleration: float = 400.0
var deceleration: float = 50

var is_turbo: bool = false
var boost_duration: float = 0.5
var turbo_timer: float

var boost_cooldown: float = 1.5
var boost_timer: float = 0

var boost_multiplier: float = 10

@onready var coin_pos_left: Marker2D = %coin_pos_left
@onready var coin_pos_right: Marker2D = %coin_pos_right
var coin_scene: PackedScene = preload("uid://bgjkqcjdfprnn")


func _ready() -> void:
	var spawn_side: int = [-1, 1].pick_random()
	
	if spawn_side == -1:
		chest_fish.global_position.x = -47
		move_right = true
	else:
		chest_fish.global_position.x = 583
		move_right = false
		chest_fish.scale.x = -1
		chest_fish.speed *= -1
	
	initial_speed = abs(chest_fish.speed)
	
	if move_right:
		target_velocity = initial_speed
	else:
		target_velocity = -initial_speed
	
	actual_velocity = target_velocity


func _process(delta: float) -> void:
	if !is_started:
		if !already_purge:
			if move_right and global_position.x > 42:
				is_started = true
			elif !move_right and global_position.x < 496:
				is_started = true
		else:
			if move_right and global_position.x > 580:
				move_right = false
				chest_fish.scale.x = -1
				chest_fish.speed *= -1
				initial_speed *= -1
				already_purge = false
			elif !move_right and global_position.x <= -40:
				move_right = true
				chest_fish.scale.x = 1
				chest_fish.speed *= -1
				initial_speed *= -1
				already_purge = false
		return
	if already_purge:
		if move_right and global_position.x > 496:
			is_started = false
		elif !move_right and global_position.x < 42:
			is_started = false
	
	_update_boost(delta)
	_update_velocity(delta)
	
	chest_fish.speed = actual_velocity


func _update_boost(delta: float) -> void:
	if !is_turbo:
		if boost_timer > 0:
			boost_timer -= delta
		else:
			target_velocity = sign(target_velocity) * initial_speed * boost_multiplier
			turbo_timer = boost_duration
			is_turbo = true
			spurge_coins()
	else:
		if turbo_timer > 0:
			turbo_timer -= delta
		else:
			target_velocity = sign(target_velocity) * initial_speed
			boost_timer = boost_cooldown
			is_turbo = false



func _update_velocity(delta: float) -> void:
	var accel := acceleration
	
	if abs(actual_velocity) > abs(target_velocity):
		accel = deceleration
	
	actual_velocity = move_toward(
		actual_velocity,
		target_velocity,
		accel * delta
	)


func spurge_coins():
	already_purge = true
	chest_fish.scale /= 1.02
	var coin_dir
	var coin_pos
	if move_right: 
		coin_dir = -1
		coin_pos = coin_pos_right.global_position
	else:
		coin_dir = 1
		coin_pos = coin_pos_right.global_position
	var coins := coin_scene.instantiate()
	for coin: CoinJumping in _get_all_coins(coins):
		coin.jump_direction = coin_dir
	get_tree().current_scene.add_child(coins)
	coins.global_position = coin_pos


func _get_all_coins(node: Node) -> Array[CoinJumping]:
	var result: Array[CoinJumping] = []
	
	if node is CoinJumping:
		result.append(node)
	
	for child in node.get_children():
		result.append_array(_get_all_coins(child))
	
	return result
