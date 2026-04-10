extends Node2D

@onready var sprite: Sprite2D = %Sprite
var up_value: float = 130
var anim_duration: float = 0.7
var time_to_disapear: float = 0.2


func _ready() -> void:
	var tween = create_tween()
	
	# movimento (começa na hora)
	tween.tween_property(
		self,
		"global_position:y",
		global_position.y - up_value,
		anim_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# fade com delay (começa depois de 0.2s, mas em paralelo)
	tween.parallel().tween_property(
		sprite,
		"modulate:a",
		0.0,
		time_to_disapear
	).set_delay(0.4)
	
	tween.tween_callback(queue_free)
