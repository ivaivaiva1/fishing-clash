extends CharacterBody2D

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
	print(actual_speed)
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
	
	if(area.is_in_group("fish_on_bait")):
		var bait: Bait = area.get_parent()
		if(bait.points != 0):
			bait.reset()



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
var chance_flipV: float = 10
var chance_flipV_again: float = 50
var was_flipedH: bool = false
var chance_flipH: float = 10
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



enum SHARK_STATE{
	IDLE,
	ATTACK,
	REST 
}
