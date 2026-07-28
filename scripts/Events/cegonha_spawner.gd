extends Node2D
class_name CegonhasSpawner

@onready var game_manager: GameManager = %Game_Manager
var cegonha_cooldown: float = 3
@onready var cegonha_timer: float = cegonha_cooldown
const cegonha: PackedScene = preload("uid://bvpehhb1kmmc3")



func _process(delta: float) -> void:
	spawn_counter(delta)
	cegonhas_timer_counter(delta)


func spawn_counter(delta: float):
	if cegonhas_enabled:
		if cegonha_timer > 0:
			cegonha_timer -= delta
		else:
			cegonha_timer = cegonha_cooldown
			spawn_cegonha()


func spawn_cegonha():
	var cegonha_instance = cegonha.instantiate()
	get_tree().current_scene.add_child(cegonha_instance)


var cegonhas_enabled: bool = false
var cegonhas_cooldown: float = 10
var cegonhas_timer: float
func do_cegonhas():
	if cegonhas_enabled: return
	cegonhas_enabled = true
	cegonhas_timer = cegonhas_cooldown
	cegonhas_enabled = true
func cegonhas_timer_counter(delta: float):
	if cegonhas_timer > 0:
		cegonhas_timer -= delta
	else:
		cegonhas_enabled = false
