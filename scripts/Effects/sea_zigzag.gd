extends Node2D

@export var zigzag_distance := 2.0
@export var zigzag_time := 0.5
@export var await_time := 1


@onready var father: Node2D = get_parent()

var start_x: float


func _ready() -> void:
	await get_tree().create_timer(await_time).timeout
	zigzag_distance = randf_range(zigzag_distance * 0.8, zigzag_distance * 1.2)
	zigzag_time = randf_range(zigzag_time * 0.8, zigzag_time * 1.2)

	start_x = father.position.x
	
	var tween := create_tween()
	
	tween.tween_property(
		father,
		"position:x",
		start_x + zigzag_distance,
		zigzag_time
	)
	
	await tween.finished
	
	var loop_tween := create_tween()
	loop_tween.set_loops()
	loop_tween.set_trans(Tween.TRANS_SINE)
	loop_tween.set_ease(Tween.EASE_IN_OUT)
	
	loop_tween.tween_property(
		father,
		"position:x",
		start_x - zigzag_distance,
		zigzag_time * 2.0
	)
	
	loop_tween.tween_property(
		father,
		"position:x",
		start_x + zigzag_distance,
		zigzag_time * 2.0
	)
