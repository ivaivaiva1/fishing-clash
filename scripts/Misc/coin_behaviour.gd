extends Node2D
class_name FallingCoin

var points: int = 10
@onready var vertical_movement: VerticalMovement = get_parent()
@onready var sprite: Sprite2D = %Sprite
var is_alive: bool = true


func _ready() -> void:
	sprite.material = sprite.material.duplicate()


func is_collected():
	is_alive = false
	var tween = create_tween()
	
	tween.parallel().tween_property(sprite.material, "shader_parameter/flash_pct", 1, 0.7)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	tween.finished.connect(func(): vertical_movement.auto_destroy())


func collect_coin() -> void:
	#vertical_movement.actual_speed *= 0.3
	
	var tween = vertical_movement.create_tween()
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	var new_shader: ShaderMaterial = sprite.material.duplicate() as ShaderMaterial
	sprite.material = new_shader
	
	tween.parallel().tween_property(new_shader, "shader_parameter/flash_pct", 0.8, 2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	#await get_tree().create_timer(0.5).timeout
	#tween.finished.connect(func(): vertical_movement.auto_destroy())
	tween.tween_callback(vertical_movement.auto_destroy)
