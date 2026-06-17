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

func _ready() -> void:
	do_jump()


func do_jump():
	velocity.y = -randf_range(130, 200)
	force_dir = [-1, 1].pick_random()
	velocity.x = force_dir * randf_range(50, 160)
	x_gravity = 200



func _process(_delta: float) -> void:
	if is_paused: return
	if is_up:
		if global_position.y < max_pos_y: auto_destroy()
	else:
		if global_position.y > 800: auto_destroy()


func _physics_process(_delta: float) -> void:
	if is_paused:
		if global_position.y < 76.648:
			velocity.y += gravity * _delta
		else:
			velocity.y += (gravity / 1.3) * _delta
		
		velocity.x = move_toward(velocity.x, 0.0, x_gravity * _delta)
		if abs(velocity.x) < 5:
			velocity.x = 0
			is_paused = false
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
	print("to destroido :c")
	queue_free()
