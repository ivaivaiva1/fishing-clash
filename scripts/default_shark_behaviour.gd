extends CharacterBody2D
class_name Shark

var shark_state: SHARK_STATE = SHARK_STATE.IDLE

@onready var actual_speed: float = shark_speed
@onready var target_speed: float = shark_speed
var shark_speed: float = 30
var attack_speed: float = 150
var rest_speed: float = 10
var dir: int = 1

@onready var sprite: AnimatedSprite2D = %sprite
@onready var vision_area_right: Area2D = %vision_area_right
@onready var vision_area_left: Area2D = %vision_area_left

func _ready() -> void:
	sprite.material = sprite.material.duplicate()


func _process(delta: float) -> void:
	lerp_speed(delta)
	match shark_state:
		SHARK_STATE.IDLE:
			shark_idle(delta)
		SHARK_STATE.ATTACK:
			shark_attack(delta)
		SHARK_STATE.REST:
			resting(delta)


func _physics_process(delta: float) -> void:
	velocity.x = (dir * actual_speed * 100) * delta
	move_and_slide()


var check_timer: float
var check_cooldown: float = 0.1
func shark_idle(delta: float):
	if check_timer > 0:
		check_timer -= delta
	else:
		check_timer = check_cooldown
		find_fish()


func find_fish():
	var target_area: Area2D
	if sprite.flip_h:
		target_area = vision_area_left
	else:
		target_area = vision_area_right
	var areas_in_vision := target_area.get_overlapping_areas()
	for area in areas_in_vision:
		check_area(area)



func start_attack():
	attack_timer = attack_cooldown
	shark_state = SHARK_STATE.ATTACK
	sprite.play("attack")

var attack_timer: float
var attack_cooldown: float = 10
func shark_attack(delta: float):
	target_speed = attack_speed
	if attack_timer > 0:
		attack_timer -= delta
	
	if attack_timer <= 0:
		start_rest()


func start_rest():
	rest_timer = rest_cooldown
	shark_state = SHARK_STATE.REST
	sprite.play("resting")

var rest_timer: float
var rest_cooldown: float = 8
func resting(delta: float):
	target_speed = rest_speed
	if rest_timer > 0:
		rest_timer -= delta
	
	if rest_timer <= 0:
		start_idle()


func start_idle():
	target_speed = shark_speed
	shark_state = SHARK_STATE.IDLE
	sprite.play("default")


func _on_body_area_area_entered(area: Area2D) -> void:
	if(area.is_in_group("shark_limit_right")):
		dir = -1
		sprite.flip_h = true
		MEME_SHARK()
	if(area.is_in_group("shark_limit_left")):
		dir = 1
		sprite.flip_h = false
		MEME_SHARK()
	
	if area.is_in_group("bubble"):
		var bubble: Bubble
		for child in area.get_parent().get_children():
			if child is Bubble:
				bubble = child as Bubble
				break
		bubble.destroy_bubble()
	
	
	if(area.is_in_group("fish_on_bait")):
		var bait: Bait = area.get_parent()
		if(bait.points != 0):
			bait.reset()
			eat_fish()


func eat_fish():
	start_attack()
	spawn_blood()
	pump_yuumy()
	do_blink()
	ScreenShake.do_screen_shake(3, 0.1)


@onready var mouth_right_top: Marker2D = %"mouth-right-top"
@onready var mouth_right_bottom: Marker2D = %"mouth-right-bottom"
@onready var mouth_left_top: Marker2D = %"mouth-left-top"
@onready var mouth_left_bottom: Marker2D = %"mouth-left-bottom"
func spawn_blood():
	var blood_pos: Vector2
	#var need_flip: bool
	if sprite.flip_h && sprite.flip_v:
		blood_pos = mouth_left_top.global_position
		#need_flip = true
	elif sprite.flip_h && !sprite.flip_v:
		blood_pos = mouth_left_bottom.global_position
		#need_flip = false
	elif !sprite.flip_h && sprite.flip_v:
		blood_pos = mouth_right_top.global_position
		#need_flip = true
	elif !sprite.flip_h && !sprite.flip_v:
		blood_pos = mouth_right_bottom.global_position
		#need_flip = false
	EffectSpawner.spawn_blood(self, blood_pos, sprite.flip_h, sprite.flip_v)




func check_area(area: Area2D):
	if(area.is_in_group("fish_on_bait")):
		var bait: Bait = area.get_parent()
		if(bait.points != 0):
			start_attack()


var lerp_force : float = 2
func lerp_speed(delta: float) -> void:
	actual_speed = lerpf(
		actual_speed,
		target_speed,
		lerp_force * delta
	)


var was_flipedV: bool = false
var chance_flipV: float = 5
var chance_flipV_again: float = 50
var was_flipedH: bool = false
var chance_flipH: float = 5
var chance_flipH_again: float = 50
func MEME_SHARK():
	var V_chance: float
	if was_flipedH:
		V_chance = chance_flipV_again
	else:
		V_chance = chance_flipV
	var H_chance: float
	if was_flipedV:
		H_chance = chance_flipH_again
	else:
		H_chance = chance_flipH
	
	var V_rand: float = randf_range(0, 100)
	var H_rand: float = randf_range(0, 100)
	if V_rand < V_chance:
		sprite.flip_v = true
		was_flipedV = true
	else:
		sprite.flip_v = false
		was_flipedV = false
	
	if H_rand < H_chance:
		if sprite.flip_h: sprite.flip_h = false
		else: sprite.flip_h = true
		was_flipedH = true
	else:
		was_flipedH = false



var pump_tween: Tween
func pump_yuumy():
	if pump_tween:
		pump_tween.kill()
	
	var original_scale := sprite.scale
	
	pump_tween = create_tween()
	
	pump_tween.parallel().tween_property(
		sprite,
		"scale:x",
		original_scale.x * 1.3,
		0.2
	)
	
	pump_tween.parallel().tween_property(
		sprite,
		"scale:y",
		original_scale.y * 1.5,
		0.2
	)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale,
		0.12
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


var blink_tween: Tween
func do_blink():
	if blink_tween:
		blink_tween.kill()
	
	sprite.material.set_shader_parameter("flash_pct", 0.0)
	
	blink_tween = create_tween()
	blink_tween.set_trans(Tween.TRANS_BACK)
	blink_tween.set_ease(Tween.EASE_OUT)
	
	blink_tween.tween_property(
		sprite.material,
		"shader_parameter/flash_pct",
		0.55,
		0.3
	)
	
	blink_tween.tween_property(
		sprite.material,
		"shader_parameter/flash_pct",
		0.0,
		0.08
	)



enum SHARK_STATE{
	IDLE,
	ATTACK,
	REST 
}
