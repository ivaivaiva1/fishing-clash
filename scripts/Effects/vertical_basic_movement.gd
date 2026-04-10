extends CharacterBody2D
class_name VerticalMovement

@export var max_pos_y: float
@export var min_speed: float
@export var max_speed: float
@export var is_up: bool
@onready var actual_speed: float = randf_range(min_speed, max_speed)


func _process(delta: float) -> void:
	if is_up:
		if global_position.y < max_pos_y: auto_destroy()
	else:
		if global_position.y > 800: auto_destroy()


func _physics_process(delta: float) -> void:
	velocity.y = actual_speed
	move_and_slide()


func auto_destroy():
	queue_free()
