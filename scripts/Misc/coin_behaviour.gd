extends Node2D
class_name FallingCoin

var points: int = 10
var father_obj
@onready var sprite: Sprite2D = %Sprite
var is_alive: bool = true
@onready var destroy_anim: AnimatedSprite2D = %destroy_anim


func _ready() -> void:
	sprite.material = sprite.material.duplicate()
	father_obj = get_parent()


func is_collected():
	if father_obj.is_paused && !father_obj.can_be_picked: return
	is_alive = false
	var tween = create_tween()
	
	tween.parallel().tween_property(sprite.material, "shader_parameter/flash_pct", 0.9, 0.7)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	tween.finished.connect(func(): destroy_coin_anim())


func destroy_coin_anim():
	father_obj.stop()
	sprite.visible = false
	destroy_anim.play("default")
	
	await destroy_anim.animation_finished
	father_obj.auto_destroy()
