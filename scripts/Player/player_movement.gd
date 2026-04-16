extends Node2D
class_name PlayerMovement

@onready var player: Player = get_parent()
@onready var sprite: Sprite2D = %Sprite
@export var speed: float = 150
@export var acceleration: float = 100.0
@export var friction: float = 200.0

var last_velocity: Vector2 = Vector2.ZERO
var knockback_force: float = 0.0
var knockback_tween: Tween

func _process(delta: float) -> void:
	player_warp()


func _physics_process(delta):
	var direction
	
	if player.current_player == 1:
		direction = Input.get_axis("move_left1", "move_right1")
	else:
		direction = Input.get_axis("move_left2", "move_right2")
	
	if direction != 0:
		sprite.flip_h = direction < 0
	
	var current_velocity = player.character_body.velocity.x
	
	
	if direction != 0:
		if sign(direction) != sign(current_velocity) and current_velocity != 0:
			player.character_body.velocity.x = move_toward(current_velocity, 0, friction * delta)
		else:
			player.character_body.velocity.x = move_toward(current_velocity, direction * speed, acceleration * delta)
	else:
		player.character_body.velocity.x = move_toward(current_velocity, 0, friction * delta)
	
	
	# aplica knockback
	player.character_body.velocity.x += knockback_force
	
	last_velocity = player.character_body.velocity
	player.character_body.move_and_slide()



func get_knockback(force: float):
	# evita múltiplos tweens ao mesmo tempo
	if knockback_tween:
		knockback_tween.kill()
	
	knockback_force = force/10
	
	knockback_tween = get_tree().create_tween()
	knockback_tween.set_ease(Tween.EASE_IN)
	knockback_tween.set_trans(Tween.TRANS_QUINT)
	knockback_tween.tween_property(self, "knockback_force", 0.0, 0.3)
	
	knockback_tween.finished.connect(_on_knockback_finished)



func _on_knockback_finished():
	knockback_tween = null




func player_warp():
	return
	if player.global_position.x < -40.206:
		player.global_position.x = 579
	if player.global_position.x > 579.266:
		player.global_position.x = -40
