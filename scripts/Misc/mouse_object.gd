extends CharacterBody2D
class_name MouseObject

@export var playerID: int
@onready var sprite: Sprite2D = %Sprite
var move_left: String
var move_right: String
var move_up: String
var move_down: String
var action: String

var max_velocity : float = 1000
var acceleration : float = 1200
var friction : float = 800

func _physics_process(delta):
	move_mouse(delta)
	rotate_mouse()

func move_mouse(delta):
	var x := Input.get_axis(move_left, move_right)
	var y := Input.get_axis(move_up, move_down)
	
	var dir := Vector2(x, y)
	
	if dir.length() > 1:
		dir = dir.normalized()
	dir.y *= 0.5
	
	
	var target_velocity = dir * max_velocity
	
	# aplica fricção sempre
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if dir != Vector2.ZERO:
		# remove componente na direção oposta (sem travar tudo)
		#var forward_speed = velocity.dot(dir)
		#if forward_speed < 0:
			#velocity -= dir * forward_speed
		
		# acelera normalmente
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	
	move_and_slide()

func rotate_mouse():
	var tilt_strength := 0.006
	var max_rotation := deg_to_rad(100)
	
	var target_rotation := 0.0
	
	# se estiver se movendo, calcula inclinação
	if abs(velocity.x) > 1:
		target_rotation = clamp(velocity.x * tilt_strength, -max_rotation, max_rotation)
	
	# suaviza sempre (inclusive voltando pra 0)
	sprite.rotation = lerp(sprite.rotation, target_rotation, 0.1)
