extends Node2D
class_name BloodEffect

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var gold_texture: Texture = preload("uid://b28ejchoxm30w")

func start(IS_BLOOD: bool) -> void:
	var target_modulate: float = 0.2
	if !IS_BLOOD:
		sprite_2d.texture = gold_texture
		target_modulate = 0.4
		sprite_2d.modulate.a = 1.0
	animation_player.play("blood_anim")
	
	var tween := create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		sprite_2d,
		"modulate:a",
		target_modulate,
		1.0
	)
