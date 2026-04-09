extends Node2D

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var auto_destruction_position: float = randf_range(145, 150)
var is_alive: bool = true


func _process(delta: float) -> void:
	if !is_alive: return
	if global_position.y < auto_destruction_position:
		destroy_bubble()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !is_alive: return
	if(area.is_in_group("bait")):
		destroy_bubble()
	
	if(area.is_in_group("shark")):
		destroy_bubble()


func destroy_bubble():
	is_alive = false
	sprite.play("kabum")
