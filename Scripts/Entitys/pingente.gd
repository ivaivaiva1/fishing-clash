extends CharacterBody2D
class_name Pingente

var actual_value: int
var red_value: int = 20
var purple_value: int = 50
@onready var sprite: AnimatedSprite2D = %Sprite

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
	auto_destroy()


func _physics_process(delta: float) -> void:
	if !is_started: return
	speed -= (speed * 1.3) * delta
	gravity += gravity_force * delta
	velocity = Vector2(speed, gravity)
	move_and_slide()


func auto_destroy():
	var blink_duration : float = 0.2
	
	for i in 6:
		var blink_tween = create_tween()
		blink_tween.set_trans(Tween.TRANS_SINE)
		blink_tween.set_ease(Tween.EASE_IN_OUT)
		
		blink_tween.tween_property(
			sprite.material,
			"shader_parameter/flash_pct",
			0.8,
			blink_duration
		)
		
		blink_tween.tween_property(
			sprite.material,
			"shader_parameter/flash_pct",
			0.0,
			blink_duration
		)
		
		await blink_tween.finished
		blink_duration -= 0.03
		
		if i == 5:
			current_bait.player.add_points(actual_value)
			queue_free()
