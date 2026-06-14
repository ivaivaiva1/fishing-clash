extends Node2D

var coin_madness_cooldown: float = 40
var coin_madness_timer: float




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("treasure"):
		start_coin_madness()
	
	
	if coin_madness_timer > 0:
		coin_madness_timer -= delta
	else:
		GlobalVars.GameManager_intance.coin_madness_enabled = false





func start_coin_madness():
	coin_madness_timer = coin_madness_cooldown
	GlobalVars.GameManager_intance.coin_madness_enabled = true
