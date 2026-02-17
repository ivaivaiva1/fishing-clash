extends Node2D
@onready var playerScript: Player = get_parent()
@onready var playerBody: CharacterBody2D = get_parent()




@export var speed: float = 80.0
@export var acceleration: float = 130.0
@export var friction: float = 200.0

func _physics_process(delta):
	var direction
	if playerScript.current_player == 1: direction = Input.get_axis("move_left1", "move_right1")
	else: direction = Input.get_axis("move_left2", "move_right2")
	
	
	if direction != 0:
		playerBody.velocity.x = move_toward(playerBody.velocity.x, direction * speed, acceleration * delta)
	else:
		playerBody.velocity.x = move_toward(playerBody.velocity.x, 0, friction * delta)
	
	playerBody.move_and_slide()
