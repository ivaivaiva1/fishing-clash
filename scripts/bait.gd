extends CharacterBody2D
class_name Bait


var input_action := ""
var player: Player
var player_name
@export var blue_fish_list: Array[Node2D] 
@export var red_fish_list: Array[Node2D] 
@export var golden_fish_list: Array[Node2D]
@onready var treasure_sprite: AnimatedSprite2D = %treasure_sprite 
@onready var coin_spawn_area: Area2D = %coin_spawn_area
@onready var bait_sprite: Sprite2D = %BaitSprite
@export var coin_scene: PackedScene 
@export var coin_jumping_scene: PackedScene 
var bait_state: String = "free"
var points = 0
var has_blue_fishs = 0
var has_red_fishs = 0
var has_golden_fishs = 0
var treasure_scale: Vector2
@onready var coin_pos: Marker2D = %coin_pos
@onready var middle_pos: Marker2D = %middle_pos



func _ready() -> void:
	player = get_parent()
	player_name = player.player_name
	input_action = player.player_name
	treasure_sprite.material = treasure_sprite.material.duplicate()
	bait_sprite.material = bait_sprite.material.duplicate()



const SWIM_FORCE = 500.0
const MAX_SPEED = 100
const ACCELERATION = 300
var actual_boost: float
const boost_force = 20
const boost_time = 0.2
var peso: float = 1
@onready var boost_controller: BoostController = %boost_controller
var feedback_tween: Tween



func _physics_process(delta):
	var target_velocity_y = 0.0
	
	if Input.is_action_just_pressed(input_action):
		boost_controller.do_boost()
		#EffectSpawner.collect_coin_effect(global_position)
		if player.game_manager.coin_madness_enabled:
			spawn_coin_falling()
		if bait_state == "treasure":
			spawn_coin_falling()
			chest_feedback()
	
	
	if Input.is_action_pressed(input_action) || actual_boost > 0:
		#if bait_state == "treasure": return
		# Jogador segurando o botão: subir
		target_velocity_y = -(MAX_SPEED * 1.3) / peso
	else:
		# Jogador não segurando: descer
		if(bait_state == "free"):
			target_velocity_y = MAX_SPEED * 0.8
		else:
			target_velocity_y = MAX_SPEED * 0.8
	
	var adjusted_boost = actual_boost / (peso / 2)
	if(actual_boost > 0): target_velocity_y -= adjusted_boost
	
	
	# Ajusta suavemente a velocidade atual em direção àvelocidade alvo
	velocity.y = move_toward(velocity.y, target_velocity_y, ACCELERATION * delta)
	
	move_and_slide()


func get_fish(fish_name: String, fish_peso: float, fish_points: float) -> void:
	bait_state = "catch"
	peso += fish_peso 
	points += fish_points
	if player_name == "player1":
		GlobalVars.player1_peso = peso
	elif player_name == "player2":
		GlobalVars.player2_peso = peso
	elif player_name == "player3":
		GlobalVars.player3_peso = peso
	elif player_name == "player4":
		GlobalVars.player4_peso = peso
	
	update_fishs(fish_name)


func get_treasure(treasure_peso: float, treasure_points: float) -> void:
	bait_state = "treasure"
	peso += treasure_peso
	points += treasure_points
	if(player_name == "player1"):
		GlobalVars.player1_peso = peso
	else:
		GlobalVars.player2_peso = peso
	
	update_fishs("treasure")


func update_fishs(fish_name: String):
	match fish_name:
		"blue":
			has_blue_fishs += 1
			if(blue_fish_list.size() < has_blue_fishs): return
			blue_fish_list[has_blue_fishs - 1].visible = true
		"red":
			has_red_fishs += 1
			if(red_fish_list.size() < has_red_fishs): return
			red_fish_list[has_red_fishs - 1].visible = true
		"golden":
			has_golden_fishs += 1
			if(golden_fish_list.size() < has_golden_fishs): return
			golden_fish_list[has_golden_fishs - 1].visible = true
		"treasure":
			treasure_sprite.visible = true
		_:
			pass


func reset_fishs():
	for fish in blue_fish_list:
		fish.visible = false
	for fish in red_fish_list:
		fish.visible = false
	for fish in golden_fish_list:
		fish.visible = false
	treasure_sprite.visible = false
	has_blue_fishs = 0
	has_red_fishs = 0
	has_golden_fishs = 0


func reset():
	bait_state = "free"
	peso = 1
	points = 0
	reset_fishs()


func spawn_coin_falling():
	var spawn_pos: Vector2
	if bait_state == "treasure":
		var shape = coin_spawn_area.get_node("CollisionShape2D").shape
		var extents = shape.extents
		var random_pos = Vector2(
			randf_range(-extents.x, extents.x),
			randf_range(-extents.y, extents.y)
		)
		spawn_pos = coin_spawn_area.to_global(random_pos)
	else:
		spawn_pos = coin_pos.global_position
	
	
	var coin = coin_jumping_scene.instantiate()
	coin.global_position = spawn_pos
	
	get_tree().current_scene.add_child(coin)


func spawn_coin_jumping():
	var coin = coin_jumping_scene.instantiate()
	coin.global_position = coin_pos.global_position
	
	get_tree().current_scene.add_child(coin)


func pulse_shader(sprite, param_name: String = "amplitude", peak_value: float = 0.03, duration: float = 0.3):
	# garante que o material não é compartilhado
	var mat = sprite.material as ShaderMaterial
	
	# mata tween anterior se quiser evitar conflito
	if sprite.has_meta("shader_tween"):
		var old_tween = sprite.get_meta("shader_tween")
		if old_tween and old_tween.is_running():
			old_tween.kill()
	
	var tween = create_tween()
	sprite.set_meta("shader_tween", tween)
	
	# sobe até o valor
	tween.tween_method(
		func(value):
			mat.set_shader_parameter(param_name, value),
		0.0,
		peak_value,
		duration * 1
	)
	
	# volta pra 0
	tween.tween_method(
		func(value):
			mat.set_shader_parameter(param_name, value),
		peak_value,
		0.0,
		duration * 0.2
	)


func chest_feedback():
	var treasure_mat = treasure_sprite.material as ShaderMaterial
	treasure_mat.set_shader_parameter("amplitude", 0.03)
	var bait_mat = bait_sprite.material as ShaderMaterial
	bait_mat.set_shader_parameter("amplitude", 0.03)
	
	# inicializa scale base se necessário
	if treasure_scale == null or treasure_scale.length() == 0:
		treasure_scale = treasure_sprite.scale
	
	# mata tween anterior
	if feedback_tween and feedback_tween.is_running():
		feedback_tween.kill()
	
	# garante estado limpo
	treasure_sprite.scale = treasure_scale
	
	feedback_tween = create_tween()
	
	
	var target_x
	var target_y
	if randi_range(0, 1) == 1:
		target_x = randf_range(1.1, 1.3)
		target_y = randf_range(0.7, 0.9)
	else:
		target_x = randf_range(0.7, 0.9)
		target_y = randf_range(1.1, 1.3)
	
	# 🔥 squash mais forte e rápido
	feedback_tween.tween_property(
		treasure_sprite,
		"scale",
		Vector2(treasure_scale.x * target_x, treasure_scale.y * target_y),
		0.1
	)
	
	# volta mais rápido também
	feedback_tween.tween_property(
		treasure_sprite,
		"scale",
		treasure_scale,
		0.05
	).set_trans(Tween.TRANS_BOUNCE)\
	 .set_ease(Tween.EASE_OUT)
	
	# 👇 zera o shader no final
	feedback_tween.tween_callback(func():
		treasure_mat.set_shader_parameter("amplitude", 0.0)
		bait_mat.set_shader_parameter("amplitude", 0.0)
	)


func _on_bait_area_area_entered(area: Area2D) -> void:
	if bait_state == "treasure": return
	if area.is_in_group("fish"):
		var fish: Fish = area.get_parent() as Fish 
		if !fish.pescavel: return 
		get_fish(fish.fish_name, fish.peso, fish.points)
		fish.spawn_catch_effect()
	
	if area.is_in_group("bubble"):
		var bubble: Bubble
		for child in area.get_parent().get_children():
			if child is Bubble:
				bubble = child as Bubble
				break
		bubble.destroy_bubble()
	
	if(area.is_in_group("coin")):
		var coin: FallingCoin
		for child in area.get_parent().get_children():
			if child is FallingCoin:
				coin = child as FallingCoin
				break
		if !coin.is_alive: return
		player.add_points(coin.points)
		coin.is_collected()
