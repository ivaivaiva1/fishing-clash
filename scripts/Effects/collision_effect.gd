extends Node2D
class_name Collision_Effect

@onready var sprite: Sprite2D = %Sprite2

var blink_duration: float = 0.8
var blink_tween: Tween


func _ready() -> void:
	sprite.material = sprite.material.duplicate()


func get_collision():
	do_blink()
	ScreenShake.do_screen_shake(3, 0.3)


func do_blink():
	if blink_tween and blink_tween.is_running():
		blink_tween.kill()
	
	_set_flash(1.0)
	
	blink_tween = create_tween()
	
	blink_tween.tween_method(
		_set_flash,
		1.0,
		0.0,
		blink_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)



func _set_flash(value: float):
	sprite.material.set_shader_parameter("flash_pct", value)
