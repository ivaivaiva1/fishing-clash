extends Node

@onready var anim_object = get_parent()
@export var auto_destroy_timer: Timer 


func on_finish_anim():
	anim_object.queue_free()


func _on_timer_timeout() -> void:
	on_finish_anim()
