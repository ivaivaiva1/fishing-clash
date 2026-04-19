extends Control

@export var ID: int
@onready var player_pin: Control = %PlayerPin
@onready var join_PB: ProgressBar = %join_progress_bar
@onready var joined_panel: Control = %joined_panel
@onready var ready_button: Control = %ready_button
var speed: float = 100
var status: State = State.NOT_JOIN

func _process(delta: float) -> void:
	if status == State.NOT_JOIN: not_join_func(delta)


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
	PLAYER_JOINED
}

func set_playerJoined_state():
	create_player()
	status = State.PLAYER_JOINED
	join_PB.visible = false
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
	MouseController.set_mouse_invisible(ID)

func create_player():
	PlayersController.new_player(ID, "a", "d", "s", "w", "space")


func _on_cancel_button_pressed() -> void:
	set_notJoin_state()
