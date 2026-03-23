extends Node

@onready var player_movement: PlayerMovement = %PlayerMovement
@onready var bait: CharacterBody2D = %bait

@export var max_speed: float = 300.0
@export var max_rotation_deg: float = 70
@export var rotation_smoothness: float = 5.0

#faca um codigo no process pra rotation do bait mudar coonforme a player_movement.last_velocity
#quanto maior a velocidade do player maior a rotacao da bait e vice versa
#faz a rotacao maxima ser 30 graus e a velocidade pra bater esse teto ser 300

func _process(delta: float) -> void:
	var vel: Vector2 = player_movement.last_velocity
	var speed: float = vel.length()
	
	# normaliza a velocidade (0 → max_speed)
	var t: float = clamp(speed / max_speed, 0.0, 1.0)
	
	# calcula rotação máxima (convertendo pra radiano)
	var max_rotation: float = deg_to_rad(max_rotation_deg)
	
	# direção da rotação baseada no eixo X da velocidade (invertida)
	var direction: float = sign(vel.x)
	
	var target_rotation: float = direction * max_rotation * t
	
	# interpolação suave
	bait.rotation = lerp(bait.rotation, target_rotation, rotation_smoothness * delta)
