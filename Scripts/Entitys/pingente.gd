extends CharacterBody2D
class_name Pingente

var actual_value: int
var red_value: int = 20
var purple_value: int = 50
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var destroy_anim: AnimatedSprite2D = %destroy_anim
@onready var middle_pos: Marker2D = %middle_pos

var is_started: bool = false
var current_bait: Bait
var speed: float 
var gravity: float = 5
var gravity_force: float = 2

func _ready() -> void:
	sprite.material = sprite.material.duplicate()
	if randf_range(0, 100) <= 30:
		sprite.play("purple")
		actual_value = purple_value
	else:
		sprite.play("red")
		actual_value = red_value


func start(bait: Bait, fish_speed: float):
	current_bait = bait
	speed = fish_speed
	is_started = true
	blink()


func _physics_process(delta: float) -> void:
	if !is_started: return
	speed -= (speed * 1.3) * delta
	gravity += gravity_force * delta
	velocity = Vector2(speed, gravity)
	move_and_slide()


func blink():
	var tween = create_tween()
	
	tween.parallel().tween_property(sprite.material, "shader_parameter/flash_pct", 0.9, 1.3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	await tween.finished
	EffectSpawner.points_label(actual_value, middle_pos.global_position)
	current_bait.player.add_points(actual_value)
	do_destroy_animation()


func do_destroy_animation():
	is_started = false
	sprite.visible = false
	destroy_anim.play("default")
	await destroy_anim.animation_finished
	queue_free()
