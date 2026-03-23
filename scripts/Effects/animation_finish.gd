extends Node

@onready var anim_object = get_parent()

func on_finish_anim():
	anim_object.queue_free()
