extends Node2D
class_name SeaShine

@export var initial_size: float = 0
@export var final_size: float 
var min_size: float = 0.7
var max_size: float = 1.4


func start() -> void:
	final_size = randf_range(min_size, max_size)
	scale = Vector2(initial_size, initial_size)
	
	var shine_tween = create_tween()
	
	
	shine_tween.tween_property(
		self,
		"scale", 
		Vector2(final_size, final_size),
		1.8
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	shine_tween.tween_interval(3)
	
	shine_tween.tween_property(
		self,
		"scale", 
		Vector2.ZERO,
		1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	shine_tween.parallel().tween_property(
		self,
		"modulate:a",
		0,
		1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	shine_tween.finished.connect(func(): queue_free())
