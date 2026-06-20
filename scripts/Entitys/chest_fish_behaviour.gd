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
var boost_duration: float = 0.5
var turbo_timer: float

var boost_cooldown: float = 1
var boost_timer: float = 0

var boost_multiplier: float = 5

@onready var coin_pos_left: Marker2D = %coin_pos_left
@onready var coin_pos_right: Marker2D = %coin_pos_right
var coin_scene: PackedScene = preload("uid://bgjkqcjdfprnn")


func _ready() -> void:
	#Engine.time_scale = 3.0
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
			if move_right and global_position.x > 35:
				is_started = true
			elif !move_right and global_position.x < 501:
				is_started = true
		else:
			if move_right and global_position.x > 580:
				turn_around()
				change_y()
				already_purge = false
			elif !move_right and global_position.x <= -40:
				turn_around()
				change_y()
				already_purge = false
		return
	
	if already_purge:
		if move_right and global_position.x > 550:
			is_started = false
		elif !move_right and global_position.x < -20:
			is_started = false
	
	_update_boost(delta)
	_update_velocity(delta)
	
	chest_fish.speed = actual_velocity



func turn_around():
	if move_right: move_right = false
	else: move_right = true
	
	
	sprite.flip_h = false if move_right else true
	target_velocity = initial_speed if move_right else -initial_speed
	actual_velocity = target_velocity
	chest_fish.speed = actual_velocity



func _update_boost(delta: float) -> void:
	if !is_turbo:
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
	print("tamo aq guys")
	var change := y_offset
	var y := chest_fish.global_position.y
	
	# Se estiver muito embaixo, sempre sobe
	if y < 200.0:
		chest_fish.global_position.y += change
		return
	elif y > 400:
		chest_fish.global_position.y -= change
		return
	
	# Se estiver muito em cima, 70% chance de descer
	if y > 325.0:
		if randf() < 0.7:
			chest_fish.global_position.y -= change
		else:
			chest_fish.global_position.y += change
		return
	
	# Caso normal: +30 ou -30 aleatório
	if randf() < 0.5:
		chest_fish.global_position.y += change
	else:
		chest_fish.global_position.y -= change
