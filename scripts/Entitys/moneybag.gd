extends CharacterBody2D

var speed: float = 10
var gravity: float = 200
@export var is_in_sea: bool = false
@onready var rotation_dir: float = [-1, 1].pick_random()
@onready var rotation_speed: float = randf_range(0, 0.7)
@onready var sprite: Sprite2D = %sprite
const COIN_CONTAINER: PackedScene = preload("uid://v5n215wsuiuk")



func _ready() -> void:
	sprite.material = sprite.material.duplicate()


func _physics_process(delta: float) -> void:
	if !is_in_sea:
		if global_position.y > 71:
			is_in_sea = true
			hit_sea()
			return
		velocity.y += gravity * delta
		rotation += (rotation_speed * rotation_dir) * delta
	else:
		velocity.y = speed
	
	move_and_slide()


func hit_sea():
	blink_tween()
	var coin_instance = COIN_CONTAINER.instantiate()
	get_tree().current_scene.add_child(coin_instance)
	coin_instance.global_position = global_position




func blink_tween():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		sprite.material,
		"shader_parameter/flash_pct",
		0.7,
		0.5
	)
	
	tween.tween_property(
		sprite.material,
		"shader_parameter/flash_pct",
		0.0,
		10
	)
	
	await tween.finished
	sprite.material = null
	get_tree().create_timer(3)
	
	var tween_a = create_tween()
	tween_a.tween_property(self, "modulate:a", 0.0, 3)
	
	await tween_a.finished
	queue_free()
