extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bubble"):
		var bubble: Bubble
		for child in area.get_parent().get_children():
			if child is Bubble:
				bubble = child as Bubble
				break
		if bubble.bubble_origin == get_parent(): return
		bubble.destroy_bubble()
		SfxManager.play_sfx(SoundsList.get_random_bubble())
