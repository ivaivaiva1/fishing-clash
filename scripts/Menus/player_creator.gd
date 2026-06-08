extends Control
class_name PlayerCreator

var device_id: int = 0
@export var ID: int
@export var input_event_names: Array[String]
@onready var player_pin: Control = %PlayerPin
@onready var join_PB: ProgressBar = %join_progress_bar
@onready var joined_panel: Control = %joined_panel
@onready var ready_button: Control = %ready_button
@onready var rebind_panel: ProgressBar = %rebind_panel
@onready var text_rebind_current_key: Label = %text_rebind_current_key
@onready var text_input_keys: Label = %text_input_keys
@onready var text_input_keys_joined_pb: Label = %text_input_keys_joinedPB
var speed: float = 100
var status: State = State.NOT_JOIN


@onready var actual_rebind_key: int = 0
var hold_time: float = 0
var current_event: InputEventKey = null



func _process(delta: float) -> void:
	if status == State.NOT_JOIN:
		not_join_func(delta)
	if status == State.BINDING:
		binding(delta)



func _input(event: InputEvent) -> void:
	if status != State.BINDING:
		return
	
	if event is InputEventKey:
		if event.pressed and not event.echo:
			#hold_time = 0
			current_event = event
		
		elif not event.pressed:
			current_event = null


func binding(delta: float):
	if current_event != null:
		hold_time += delta * 80
		rebind_panel.value = hold_time
	else:
		if hold_time < 0:
			hold_time = 0
		else:
			hold_time -= delta * 120
		rebind_panel.value = hold_time
	
	
	rebind_panel.value = clamp(rebind_panel.value, 0, 100)
	if rebind_panel.value >= 100 && current_event != null:
		set_key(current_event)


func set_key(event: InputEventKey):
	var action_name = input_event_names[actual_rebind_key]
	
	InputMap.action_erase_events(action_name)
	
	InputMap.action_add_event(action_name, event)
	
	update_keys_preview()
	
	current_event = null
	hold_time = 0
	if actual_rebind_key < 4:
		actual_rebind_key += 1
		text_rebind_current_key.text = input_event_names[actual_rebind_key]
	else:
		set_playerJoined_state()



func not_join_func(delta: float):
	var any_key := false
	
	for key in range(256): # pega várias teclas comuns
		if Input.is_key_pressed(key):
			any_key = true
			break
	 
	if any_key:
		join_PB.value += speed * delta
	else:
		join_PB.value -= (speed * 1.5) * delta
	
	join_PB.value = clamp(join_PB.value, 0, join_PB.max_value)
	if join_PB.value == join_PB.max_value:
		set_playerJoined_state()




enum State {
	NOT_JOIN,
	PLAYER_JOINED,
	BINDING
}


func set_playerJoined_state():
	create_player()
	#update_keys_preview()
	status = State.PLAYER_JOINED
	join_PB.visible = false
	rebind_panel.visible = false
	player_pin.visible = true
	joined_panel.visible = true
	MouseController.set_mouse_visible(ID, ready_button.global_position + Vector2(33, -10))



func set_notJoin_state():
	PlayersController.remove_player(ID)
	join_PB.value = 0
	status = State.NOT_JOIN
	join_PB.visible = true
	player_pin.visible = false
	joined_panel.visible = false
	rebind_panel.visible = false
	MouseController.set_mouse_invisible(ID)

 
func set_rebind_state():
	status = State.BINDING
	actual_rebind_key = 0
	text_rebind_current_key.text = "HOLD TO BIND - LEFT"
	MouseController.set_mouse_invisible(ID)
	joined_panel.visible = false
	rebind_panel.visible = true


func create_player():
	PlayersController.new_player(ID, "a", "d", "s", "w", "space")


func _on_cancel_button_pressed() -> void:
	set_notJoin_state()


func _on_rebind_button_button_down() -> void:
	set_rebind_state()


func update_keys_preview():
	var text := ""
	
	for action_name in input_event_names:
		var events = InputMap.action_get_events(action_name)
		
		var key_name := "None"
		
		if events.size() > 0:
			var event = events[0]
			
			if event is InputEventKey:
				key_name = OS.get_keycode_string(event.keycode)
		
		text += "-      " + key_name + "\n"
	
	text_input_keys.text = text
	text_input_keys_joined_pb.text = text


func _on_ready_button_button_down() -> void:
	get_tree().change_scene_to_file("res://_scenes/game.tscn")
