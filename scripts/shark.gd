extends CharacterBody2D
class_name SharkERRADO

var speed: float = 20
var speed_multiplier: float = 1
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
var is_attack: bool = false
var can_attack: bool = true
var attack_timer: float = 0
var attack_duration: float = 5
var moving_right: bool = true
var is_resting_cooldown = 3
var is_resting_timer = -100


func _process(delta):
	anim_handler()
	if(is_resting_timer > 0):
		is_resting_timer -= delta
	
	if(is_attack):
		if(attack_timer > 0):
			attack_timer -= delta
		else:
			stop_attack()


func _physics_process(delta):
	velocity = Vector2(speed * speed_multiplier, 0)
	move_and_slide()


func attack():
	if(is_resting_timer > 0): return
	sprite.play("attack")
	attack_timer = attack_duration
	speed = 200
	is_attack = true


func stop_attack():
	is_resting_timer = is_resting_cooldown
	speed = 20
	is_attack = false


func re_start():
	global_position = Vector2(-66, 138.901)


func _on_vision_area_area_entered(area: Area2D) -> void:             
	if(area.is_in_group("fish_on_bait")):
		var bait: Bait = area.get_parent()
		if(bait.points != 0):
			attack()

func anim_handler():
	if is_attack == false:
		if is_resting_timer < 0:
			sprite.play("default")
		else:
			sprite.play("resting")
	else:
		sprite.play("attack")


func _on_body_area_area_entered(area: Area2D) -> void:
	if(area.is_in_group("fish_on_bait")):
		var bait: Bait = area.get_parent()
		if(bait.points != 0):
			bait.reset()
	
	if area.is_in_group("bubble"):
		var bubble: Bubble
		for child in area.get_parent().get_children():
			if child is Bubble:
				bubble = child as Bubble
				break
		bubble.destroy_bubble()
	
	if(area.is_in_group("shark_limit_left")):
		if(!moving_right):
			moving_right = true
			speed_multiplier = 1
			#sprite.flip_h = false
			scale = Vector2(1, 1)
	
	if(area.is_in_group("shark_limit_right")):
		if(moving_right):
			moving_right = false
			speed_multiplier = -1
			#sprite.flip_h = true
			scale = Vector2(-1, 1)
