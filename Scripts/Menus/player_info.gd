extends Node2D
class_name PlayerInfo

var money_label: RichTextLabel
var points_label: RichTextLabel 
var empty_label: RichTextLabel
var empty_int: int = 1

var active_ui: Node2D 
var empty_ui: Node2D 
var empty_timer: Timer


func make_active():
	active_ui = %active_ui
	active_ui.visible = true


func make_empty():
	empty_ui = %empty_ui
	empty_ui.visible = true
	
	empty_label = %empty_label
	empty_timer = %empty_timer
	empty_timer.start()
	await empty_timer.timeout
	while(true):
		if empty_label.visible:
			empty_label.visible = false
			empty_timer.wait_time = 0.5
		else:
			if empty_int == 1:
				empty_label.text = "TO PLAY"
				empty_int = 0
			else:
				empty_label.text = "PRESS SPACE"
				empty_int += 1
			empty_label.visible = true
			empty_timer.wait_time = 0.5
		empty_timer.start()
		await empty_timer.timeout


func att_money_label(value: int):
	if money_label == null:
		money_label = %money_label
	money_label.text = "$" + format_money(value)


func att_points_label(value: int):
	if points_label == null:
		points_label = %points_label
	points_label.text = str(value)



func format_money(value: int) -> String:
	var s := str(value)
	var result := ""
	
	while s.length() > 3:
		result = "." + s.right(3) + result
		s = s.left(s.length() - 3)
	
	return s + result
