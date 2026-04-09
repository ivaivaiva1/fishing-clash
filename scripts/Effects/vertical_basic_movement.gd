extends CharacterBody2D

@export var max_pos_y: float
@export var min_speed: float
@export var max_speed: float
@export var is_up: bool


func _physics_process(delta: float) -> void:
	if is_up:
		if global_position.y < max_pos_y: queue_free()
	else:
		if global_position.y > 800: queue_free()
	
	
	velocity.y = randf_range(min_speed, max_speed)
	move_and_slide()
