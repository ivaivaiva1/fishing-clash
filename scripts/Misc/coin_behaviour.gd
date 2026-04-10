extends Node2D

@onready var vertical_movement: VerticalMovement = get_parent()
@onready var sprite: Sprite2D = %Sprite
var is_alive: bool = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !is_alive: return
	if(area.is_in_group("bait")):
		var bait: Bait = area.get_parent()
		if(bait.bait_state == "treasure"): return
		is_alive = false
		bait.player.add_points(10)
		EffectSpawner.collect_coin_effect(bait.bait_sprite.global_position - Vector2(0, 15))
		vertical_movement.auto_destroy()
		#collect_coin()



func collect_coin() -> void:
	#vertical_movement.actual_speed *= 0.3
	
	var tween = vertical_movement.create_tween()
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	var new_shader: ShaderMaterial = sprite.material.duplicate() as ShaderMaterial
	sprite.material = new_shader
	
	tween.parallel().tween_property(new_shader, "shader_parameter/flash_pct", 0.8, 2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	#await get_tree().create_timer(0.5).timeout
	#tween.finished.connect(func(): vertical_movement.auto_destroy())
	tween.tween_callback(vertical_movement.auto_destroy)
