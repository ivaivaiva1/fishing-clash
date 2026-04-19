extends Node

@onready var bait_character_body: CharacterBody2D = get_parent()
@onready var bait_class: Bait = get_parent()
@onready var player_movement: PlayerMovement


@export var max_speed: float = 300.0
@export var max_rotation_deg: float = 70
@export var rotation_smoothness: float = 5.0


func _process(delta: float) -> void:
	if player_movement == null: 
		get_playerMovement()
		return
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
	bait_character_body.rotation = lerp(bait_character_body.rotation, target_rotation, rotation_smoothness * delta)


func get_playerMovement():
	player_movement = bait_class.player.player_movement
