extends CharacterBody2D
class_name Fish

@export var fish_name: String
@export var speed: float
@export var auto_destruction_timer: float
@export var peso: float
@export var points: float
@export var effect_size: float
@export var do_bubble: bool = true
var move_right: bool = true
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var right_effectPos: Marker2D = %right_effectPos
@onready var left_effectPos: Marker2D = %left_effectPos
var shiny_rain = false
@onready var fish_characterbody: CharacterBody2D = self
@export var pescavel: bool = true
var is_shiny: bool = false



func _ready():
	if !pescavel: return
	sprite.material = sprite.material.duplicate()
	
	if shiny_rain:
		make_shiny(true)
	elif randf_range(0, 100) < 2:
		make_shiny(true)
	
	
	if(!move_right):
		speed = speed * -1
		scale.x = -1
		#sprite.flip_h = true
	if(fish_name != "red"): 
		speed = randf_range(speed * 0.8, speed * 1.2)
	
	sprite.z_index = randi_range(0, 10)
	
	var reduction_percent = (10 - sprite.z_index) * 0.01
	reduction_percent = clamp(reduction_percent, 0.0, 0.10)
	
	var final_scale = 1.0 - reduction_percent
	scale *= final_scale




func _process(delta):
	auto_destruction_timer -= delta
	if(auto_destruction_timer < 0):
		queue_free()
	
	if !do_bubble: return
	if bubble_timer > 0:
		bubble_timer -= delta
	if  bubble_timer < 0:
		spawn_bubble()




func _physics_process(_delta):
	velocity = Vector2(speed, 0)
	move_and_slide()


@onready var time_to_bubble: float = randf_range(min_bubble_time, max_bubble_time)
@onready var bubble_timer: float = time_to_bubble
@onready var bubble_rightPos: Marker2D = %bubble_rightPos
@onready var bubble_leftPos: Marker2D = %bubble_leftPos
var min_bubble_time: float = 0.5
var max_bubble_time: float = 40
var double_bouble_change: float = 10
func spawn_bubble():
	var bubble_pos: Vector2
	#if sprite.flip_h: bubble_pos = bubble_rightPos.global_position
	#else: bubble_pos = bubble_leftPos.global_position
	bubble_pos = bubble_rightPos.global_position
	
	EffectSpawner.spawn_bubble(bubble_pos, (effect_size * scale.x), (sprite.z_index + 1))
	bubble_timer = randf_range(min_bubble_time, max_bubble_time)
	var doubleB_rand: float = randf_range(0, 100)
	if doubleB_rand < double_bouble_change:
		spawn_bubble()


func spawn_catch_effect():
	var spawn_pos: Vector2
	#if move_right: spawn_pos = right_effectPos.global_position
	#else: spawn_pos = left_effectPos.global_position
	spawn_pos = right_effectPos.global_position
	EffectSpawner.spawn_effect(spawn_pos, effect_size)
	queue_free()


func make_shiny(is_borning: bool = false):
	if is_shiny: return
	is_shiny = true
	points *= 5
	peso *= 2
	
	if is_borning:
		sprite.play("shiny")
		return
	shiny_pump()
	do_blink()
	await get_tree().create_timer(0.3).timeout
	sprite.play("shiny")


func do_blink():
	sprite.material.set_shader_parameter("flash_pct", 0.0)
	
	var blink_tween = create_tween()
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
		0.5
	)


func shiny_pump():
	var original_scale := sprite.scale
	
	var pump_tween = create_tween()
	pump_tween.set_trans(Tween.TRANS_SINE)
	pump_tween.set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * 1.3,
		0.1
	)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * 0.8,
		0.1
	)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * 1.15,
		0.1
	)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * 0.9,
		0.1
	)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * 1.07,
		0.1
	)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale,
		0.1
	)
