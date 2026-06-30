extends Node2D
class_name PlayerInfo

var money_label: RichTextLabel
var points_label: RichTextLabel 

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
