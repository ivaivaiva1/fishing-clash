extends Node
class_name SkinHandler

@onready var sprite_arrow: Sprite2D = %arrow_sprite
@onready var sprite: Sprite2D = %Sprite
@onready var bait: Bait = %bait

func set_skins(playerId: int):
	if playerId == 1:
		sprite_arrow.texture = PlayersSkins.player1_arrow_texture
		sprite.texture = PlayersSkins.player1_boat_texture
		bait.bait_sprite.texture = PlayersSkins.player1_bait_texture
	elif playerId == 2:
		sprite_arrow.texture = PlayersSkins.player2_arrow_texture
		sprite.texture = PlayersSkins.player2_boat_texture
		bait.bait_sprite.texture = PlayersSkins.player2_bait_texture
	elif playerId == 3:
		sprite_arrow.texture = PlayersSkins.player3_arrow_texture
		sprite.texture = PlayersSkins.player3_boat_texture
		bait.bait_sprite.texture = PlayersSkins.player3_bait_texture
	elif playerId == 4:
		sprite_arrow.texture = PlayersSkins.player4_arrow_texture
		sprite.texture = PlayersSkins.player4_boat_texture
		bait.bait_sprite.texture = PlayersSkins.player4_bait_texture
