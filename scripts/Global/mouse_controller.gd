extends Node2D

@onready var mouse_global: MouseObject = %mouse_global



func _ready() -> void:
	mouse_global.move_left = "main_mouse_left"
	mouse_global.move_right = "main_mouse_right"
	mouse_global.move_up = "main_mouse_up"
	mouse_global.move_down = "main_mouse_down"
	mouse_global.action = "main_mouse_action"
