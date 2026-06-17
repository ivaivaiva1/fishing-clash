extends CharacterBody2D
class_name CoinJumping

@export var max_pos_y: float
@export var min_speed: float
@export var max_speed: float
@export var is_up: bool
@onready var actual_speed: float = randf_range(min_speed, max_speed)
var gravity: float = 400
var x_gravity: float 
var force_dir: int
@export var is_paused: bool = false
@onready var zig_zag: ZigZag = %sea_zigzag
@export var min_jump_force_y: float = 130
@export var max_jump_force_y: float = 200
@export var min_jump_force_x: float = 50
@export var max_jump_force_x: float = 160
@onready var coin_behaviour: FallingCoin = %coin_behaviour
@export var can_be_picked: bool = true


var target_bait: Marker2D
var follow_player: bool = false
var move_direction


func _ready() -> void:
	do_jump()


func do_jump():
	velocity.y = -randf_range(min_jump_force_y, max_jump_force_y)
	force_dir = [-1, 1].pick_random()
	velocity.x = force_dir * randf_range(min_jump_force_x, max_jump_force_x)
	x_gravity = 200



func _process(_delta: float) -> void:
	if is_paused: return
	if is_up:
		if global_position.y < max_pos_y: auto_destroy()
	else:
		if global_position.y > 800: auto_destroy()


func _physics_process(_delta: float) -> void:
	if follow_player:
		set_bait_direction()
		if global_position.distance_to(target_bait.global_position) < 5 || !coin_behaviour.is_alive:
			velocity = move_direction * 20
		else:
			velocity = move_direction * 70 * 2
	elif is_paused:
		if global_position.y < 76.648:
			velocity.y += gravity * _delta
		else:
			velocity.y += (gravity / 1.3) * _delta
		
		velocity.x = move_toward(velocity.x, 0.0, x_gravity * _delta)
		if abs(velocity.x) < 5:
			velocity.x = 0
			is_paused = false
			if zig_zag == null: return
			zig_zag.start()
	else:
		if global_position.y < 76.648:
			velocity.y += gravity * _delta
		else:
			velocity.y = actual_speed
	
	move_and_slide()


func stop():
	is_paused = true


func auto_destroy():
	queue_free()


func set_bait_direction():
	if !follow_player: return
	if target_bait == null: return
	var difference = target_bait.global_position - global_position
	move_direction = difference.normalized()


func _on_bait_area_area_entered(area: Area2D) -> void:
	if !can_be_picked && is_paused: return
	if follow_player: return
	if zig_zag == null: return
	if area.is_in_group("bait"):
		var bait: Bait = area.get_parent() as Bait
		if bait.bait_state == "treasure": return
		zig_zag.queue_free()
		target_bait = bait.middle_pos
		follow_player = true
