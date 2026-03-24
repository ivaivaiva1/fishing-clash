extends CharacterBody2D

@export var fish_name: String
@export var speed: float
@export var auto_destruction_timer: float
@export var peso: float
@export var points: float
@export var effect_size: float
var move_right: bool = true
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var right_effectPos: Marker2D = %right_effectPos
@onready var left_effectPos: Marker2D = %left_effectPos
var red_rain = false




func _ready():
	if(!move_right):
		speed = speed * -1
		scale.x = -1
		#sprite.flip_h = true
	if(fish_name != "red"): 
		speed = randf_range(speed * 0.8, speed * 1.2)
	else:
		if red_rain: speed *= 2




func _process(delta):
	auto_destruction_timer -= delta
	if(auto_destruction_timer < 0):
		queue_free()

func _physics_process(delta):
	velocity = Vector2(speed, 0)
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("bait")):
		var bait: Bait = area.get_parent()
		#if(bait.bait_state != "free"): return
		bait.get_fish(fish_name, peso, points)
		spawn_catch_effect()
		queue_free()


func spawn_catch_effect():
	var spawn_pos: Vector2
	if move_right: spawn_pos = right_effectPos.global_position
	else: spawn_pos = left_effectPos.global_position
	EffectSpawner.spawn_effect(spawn_pos, effect_size)
