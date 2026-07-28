extends Node2D
class_name FallingCoin

var points: int = 10
var father_obj
@onready var sprite: Sprite2D = %Sprite
var is_alive: bool = true
@onready var destroy_anim: AnimatedSprite2D = %destroy_anim

@onready var texture_mini: Texture2D = preload("uid://jb37680fte1w")
@onready var texture_gold: Texture2D = preload("uid://cfmmwox84vcu3")
@onready var texture_blue: Texture2D = preload("uid://d0nwlh0hnv7q2")
@onready var texture_red: Texture2D = preload("uid://iqap0e5xbpys")
@onready var texture_purple: Texture2D = preload("uid://cqe3c6qaxdpxh")


func _ready() -> void:
	sprite.material = sprite.material.duplicate()
	father_obj = get_parent()
	
	
	if randf_range(0, 100) < father_obj.purple_chance:
		sprite.texture = texture_purple
		points = father_obj.purple_value
		father_obj.scale = Vector2(0.8, 0.8)
	elif randf_range(0, 100) < father_obj.red_chance:
		sprite.texture = texture_red
		points = father_obj.red_value
	elif randf_range(0, 100) < father_obj.blue_chance:
		sprite.texture = texture_blue
		points = father_obj.blue_value
		father_obj.scale = Vector2(1.05, 1.05)
	elif randf_range(0, 100) < father_obj.yellow_chance:
		sprite.texture = texture_gold
		points = father_obj.yellow_value
	else:
		sprite.texture = texture_mini
		points = father_obj.mini_value
		father_obj.scale = Vector2(0.65, 0.65)




func is_collected():
	if father_obj.is_paused && !father_obj.can_be_picked: return
	is_alive = false
	var tween = create_tween()
	
	tween.parallel().tween_property(sprite.material, "shader_parameter/flash_pct", 0.9, 0.7)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	tween.finished.connect(func(): destroy_coin_anim())


func destroy_coin_anim():
	father_obj.stop()
	sprite.visible = false
	destroy_anim.play("default")
	
	await destroy_anim.animation_finished
	father_obj.auto_destroy()
