extends Node2D
class_name Bubble

var bubble_origin
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var auto_destruction_position: float = randf_range(120, 130)
var is_alive: bool = true


func _process(_delta: float) -> void:
	if !is_alive: return
	if global_position.y < auto_destruction_position:
		destroy_bubble()


func destroy_bubble():
	if !is_alive: return
	is_alive = false
	sprite.play("kabum")
