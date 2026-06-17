extends Node2D

@onready var game_manager: GameManager = %Game_Manager
var cegonha_cooldown: float = 3
@onready var cegonha_timer: float = cegonha_cooldown
const cegonha: PackedScene = preload("uid://bvpehhb1kmmc3")





func _process(delta: float) -> void:
	if game_manager.cegonnhas_enabled:
		if cegonha_timer > 0:
			cegonha_timer -= delta
		else:
			cegonha_timer = cegonha_cooldown
			spawn_cegonha()



func spawn_cegonha():
	var cegonha_instance = cegonha.instantiate()
	get_tree().current_scene.add_child(cegonha_instance)
