extends Node2D

@onready var bait: Bait = get_parent() 
var effected_coins: Array = []
var magnetic_force: float = 300

#
#func _process(delta: float) -> void:
	#if effected_coins.size() == 0: return
	#for coin in effected_coins:
		#if !coin: 
			#effected_coins.erase(coin)
			#return
		#var dir = bait.global_position - coin.global_position
		#coin.global_position += dir.normalized() * magnetic_force * delta
#
#
#func _on_magnetic_area_area_entered(area: Area2D) -> void:
	#if area.is_in_group("coin"):
		#effected_coins.append(area)
