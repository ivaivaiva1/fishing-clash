extends Node2D

@export var zigzag_distance := 2.0
@export var zigzag_time := 0.5
@export var await_time := 0.1
var changeDIR_chance: float 
@export var is_horizontal := true
@export var is_fish := false
@export var transition: Tween.TransitionType = Tween.TRANS_SINE
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT



@onready var father: Node2D = get_parent()

var start_position: Vector2


func _ready() -> void:
	await get_tree().create_timer(await_time).timeout
	if is_fish:
		zig_zague_tween()
		return
	if get_parent().get_parent().name == "treasure_container":
		changeDIR_chance = 80
		zig_zague2()
	else:
		#zig_zague_tween()
		changeDIR_chance = 20
		zig_zague2()



func zig_zague_tween():
	zigzag_distance = randf_range(zigzag_distance * 0.8, zigzag_distance * 1.2)
	zigzag_time = randf_range(zigzag_time * 0.8, zigzag_time * 1.2)
	
	start_position = father.global_position
	
	var tween := create_tween()
	
	if is_horizontal:
		tween.tween_property(
			father,
			"global_position:x",
			start_position.x + zigzag_distance,
			zigzag_time
		)
	else:
		tween.tween_property(
			father,
			"global_position:y",
			start_position.y + zigzag_distance,
			zigzag_time
		)
	
	await tween.finished
	
	var loop_tween := create_tween()
	loop_tween.set_loops()
	loop_tween.set_trans(transition)
	loop_tween.set_ease(ease_type)
	
	if is_horizontal:
		loop_tween.tween_property(
			father,
			"global_position:x",
			start_position.x - zigzag_distance,
			zigzag_time * 2.0
		)
	
		loop_tween.tween_property(
			father,
			"global_position:x",
			start_position.x + zigzag_distance,
			zigzag_time * 2.0
		)
	else:
		loop_tween.tween_property(
			father,
			"global_position:y",
			start_position.y - zigzag_distance,
			zigzag_time * 2.0
		)
	
		loop_tween.tween_property(
			father,
			"global_position:y",
			start_position.y + zigzag_distance,
			zigzag_time * 2.0
		)


func zig_zague2():
	print("zigue_zaque")
	zigzag2_step(1)


func zigzag2_step(direction: int):
	var tween = create_tween()
	
	tween.tween_property(
		father,
		"global_position:x",
		global_position.x + (zigzag_distance * direction),
		zigzag_time
	)
	
	await tween.finished
	
	var changeDir_rand: float = randf_range(0, 100)
	if changeDir_rand >= changeDIR_chance:
		direction *= -1
	
	
	zigzag2_step(direction)
