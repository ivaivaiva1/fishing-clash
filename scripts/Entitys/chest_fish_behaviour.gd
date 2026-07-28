extends Node2D

var already_purge: bool = false
@onready var chest_fish: Fish = get_parent() as Fish
var sprite: AnimatedSprite2D

var move_right: bool
var initial_speed: float
var is_started: bool

var target_velocity: float
var actual_velocity: float

var acceleration: float = 400.0
var deceleration: float = 50

var is_turbo: bool = false
var turbo_timer: float
var boost_timer: float = 0

var boost_multiplier: float = 5
var boost_duration: float = 0.5
var boost_cooldown: float = 1

var default_boost_multiplier: float = 5
var default_boost_duration: float = 0.5
var default_boost_cooldown: float = 1.0

var cagao_boost_multiplier: float = 10
var cagao_boost_duration: float = 0.2
var cagao_boost_cooldown: float = 0.4


var has_coins: int = 25
var is_cagao: bool = false
@onready var coin_pos_left: Marker2D = %coin_pos_left
@onready var coin_pos_right: Marker2D = %coin_pos_right
var coin_scene: PackedScene = preload("uid://bgjkqcjdfprnn")


func _ready() -> void:
	var spawn_side: int = [-1, 1].pick_random()
	sprite = %AnimatedSprite2D
	
	if spawn_side == -1:
		chest_fish.global_position.x = -47
		move_right = true
		#chest_fish.scale.x = 1
	else:
		chest_fish.global_position.x = 583
		move_right = false
		sprite.flip_h = true
	
	initial_speed = abs(chest_fish.speed)
	
	target_velocity = initial_speed if move_right else -initial_speed
	actual_velocity = target_velocity
	chest_fish.speed = actual_velocity
	
	var y_pos = randf_range(220, 320)
	chest_fish.global_position.y = y_pos
	change_y()



func _process(delta: float) -> void:
	if !is_started:
		if !already_purge:
			if move_right and global_position.x > 25:
				is_started = true
			elif !move_right and global_position.x < 501:
				is_started = true
		else:
			if move_right and global_position.x > 580:
				do_change_direction()
			elif !move_right and global_position.x <= -40:
				do_change_direction()
		return
	
	if already_purge:
		if move_right and global_position.x > 550:
			is_started = false
		elif !move_right and global_position.x < -20:
			is_started = false
	
	_update_boost(delta)
	_update_velocity(delta)
	
	chest_fish.speed = actual_velocity


func do_change_direction():
	already_purge = false
	boost_timer = 0
	turbo_timer = 0
	turn_around()
	change_y()
	do_cagao()



func turn_around():
	if move_right: move_right = false
	else: move_right = true
	
	
	sprite.flip_h = false if move_right else true
	target_velocity = initial_speed if move_right else -initial_speed
	actual_velocity = target_velocity
	chest_fish.speed = actual_velocity



func _update_boost(delta: float) -> void:
	if !is_turbo:
		if has_coins <= 0: 
			if !chest_fish.pescavel:
				chest_fish.pescavel = true
			return
		if boost_timer > 0:
			boost_timer -= delta
		else:
			target_velocity = (
				initial_speed * boost_multiplier
				if move_right
				else
				-initial_speed * boost_multiplier
			)
			turbo_timer = boost_duration
			is_turbo = true
			spurge_coins()
	else:
		if turbo_timer > 0:
			turbo_timer -= delta
		else:
			target_velocity = (
				initial_speed
				if move_right
				else
				-initial_speed
			)
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
	ScreenShake.do_screen_shake(2, 0.1)
	has_coins -= 1
	already_purge = true
	chest_fish.scale *= 0.98
	
	var coin_dir
	var coin_pos
	
	if move_right:
		coin_dir = -1
		coin_pos = coin_pos_right.global_position
	else:
		coin_dir = 1
		coin_pos = coin_pos_left.global_position
	
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



var y_offset: float = 50
func change_y() -> void:
	var change := y_offset
	var y := chest_fish.global_position.y
	
	if y < 200.0:
		chest_fish.global_position.y += change
		return
	elif y > 400:
		chest_fish.global_position.y -= change
		return
	
	if y > 325.0:
		if randf() < 0.7:
			chest_fish.global_position.y -= change
		else:
			chest_fish.global_position.y += change
		return
	if randf() < 0.5:
		chest_fish.global_position.y += change
	else:
		chest_fish.global_position.y -= change


func do_cagao():
	if is_cagao: 
		is_cagao = false
		boost_multiplier = default_boost_multiplier
		boost_duration = default_boost_duration
		boost_cooldown = default_boost_cooldown
		return
	
	var cagao_chance: float = randf_range(0, 100)
	if cagao_chance <= 20:
		is_cagao = true
		boost_multiplier = cagao_boost_multiplier
		boost_duration = cagao_boost_duration
		boost_cooldown = cagao_boost_cooldown
