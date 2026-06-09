extends Node2D

@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	var tween := create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		sprite_2d,
		"modulate:a",
		0.2,
		1.0
	)
