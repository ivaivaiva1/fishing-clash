extends Node2D

var treasure_peso: float = 3
var treasure_points: float = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#global_position.x = get_viewport().get_camera_2d().get_screen_center_position().x
	#global_position.y = 800
	treasure_appear()



func treasure_appear():
	var tween = create_tween()
	
	tween.tween_property(self, "global_position:y", 432, 20)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("bait")):
		var bait: Bait = area.get_parent()
		if bait.bait_state != "free": return
		bait.get_treasure(treasure_peso, treasure_points)
		queue_free()
