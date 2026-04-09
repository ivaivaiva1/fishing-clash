extends Node

@onready var sprite: AnimatedSprite2D = %Sprite

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("bait")):
		sprite.play("kabum")
	
	if(area.is_in_group("shark")):
		sprite.play("kabum")
