extends CharacterBody2D

var moneybag_pos: float = randf_range(26, 510) 
var min_speed: float = 350
var max_speed: float = 450
var speed: float = randf_range(min_speed, max_speed)
var dir
var has_money_bag: bool = true
var moneybag: PackedScene = preload("uid://mboxchoqsmho")
@onready var sprite: Sprite2D = %sprite
@onready var moneybag_sprite: Sprite2D = %moneybag
@onready var marker_left: Marker2D = %MarkerLeft
@onready var marker_right: Marker2D = %MarkerRight


func _ready() -> void:
	dir = [-1, 1].pick_random()
	if dir > 0:
		global_position.x = -185
		sprite.flip_h = false
		moneybag_sprite.position = Vector2(53, 17.84)
	else:
		sprite.flip_h = true
		global_position.x = 680



func _physics_process(delta: float) -> void:
	if has_money_bag:
		if abs(global_position.x - moneybag_pos) < 10:
			let_bag()
	velocity.x = dir * (speed * 10) * delta
	move_and_slide()


func let_bag():
	has_money_bag = false
	moneybag_sprite.visible = false
	var moneybag_intance = moneybag.instantiate()
	get_tree().current_scene.add_child(moneybag_intance)
	if dir > 0:
		moneybag_intance.global_position = marker_right.global_position
	else:
		moneybag_intance.global_position = marker_left.global_position
