extends Node2D

@onready var mouse_global: MouseObject = %mouse_global
@onready var mouse1: MouseObject = %mouse_player1


func _ready() -> void:
	mouse_global.move_left = "main_mouse_left"
	mouse_global.move_right = "main_mouse_right"
	mouse_global.move_up = "main_mouse_up"
	mouse_global.move_down = "main_mouse_down"
	mouse_global.action = "main_mouse_action"




func set_mouse_visible(mouseID: int, pos: Vector2 = Vector2.ZERO):
	var setup_mouse: MouseObject
	match mouseID:
		0:
			setup_mouse = mouse_global
		1:
			setup_mouse = mouse1
	setup_mouse.visible = true
	setup_mouse.is_active = true
	if pos != Vector2.ZERO:
		setup_mouse.global_position = pos


func set_mouse_invisible(mouseID: int):
	match mouseID:
		0:
			mouse_global.visible = false
		1:
			mouse1.visible = false
