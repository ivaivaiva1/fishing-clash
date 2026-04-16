extends Node2D
class_name Collision_Effect

@onready var sprite: Sprite2D = %Sprite
@onready var pump_animation: AnimationPlayer = %PumpAnimation
var blink_duration: float = 0.8
var blink_tween: Tween


func _ready() -> void:
	sprite.material = sprite.material.duplicate()


func get_collision():
	do_blink()
	#do_squash()
	pump_animation.play("pump_1")
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

var squash_tween: Tween

#func do_squash():
	#if squash_tween and squash_tween.is_running():
		#squash_tween.kill()
	#
	## garante que começa do estado base
	#sprite.scale = base_sprite_scale
	#
	#squash_tween = create_tween()
	#
	## --- Fase 1 (0.15s)
	## X +20%, Y -40%
	#squash_tween.tween_property(
		#sprite, "scale",
		#Vector2(base_sprite_scale.x * 1.2, base_sprite_scale.y * 0.6),
		#0.15
	#).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#
	## --- Fase 2 (0.35s)
	## X 70%, Y +20%
	#squash_tween.tween_property(
		#sprite, "scale",
		#Vector2(base_sprite_scale.x * 0.7, base_sprite_scale.y * 1.2),
		#0.35
	#).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	#
	## --- Fase 3 (0.2s)
	## volta ao normal
	#squash_tween.tween_property(
		#sprite, "scale",
		#base_sprite_scale,
		#0.2
	#).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
