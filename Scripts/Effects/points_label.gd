extends Node2D
class_name PointsLabel

@onready var label: RichTextLabel = %Label
@onready var timer: Timer = %Timer

func start(value: int):
	label.text = str(value)
	for i in 15:
		global_position.y -= 1
		if i > 6:
			if visible:
				visible = false
			else:
				visible = true
		timer.start()
		await timer.timeout
		if i == 14:
			queue_free()
