extends Node
class_name BoostController

@onready var bait: Bait = get_parent()
var actual_boosts: Array[boost_data] = []


func _process(delta: float) -> void:
	update_boost_value()


class boost_data:
	var boost_force: float
	var boost_decay_time: float
	var tween: Tween  


func do_boost():
	var boost_instance: boost_data = boost_data.new()
	boost_instance.boost_force = bait.boost_force
	boost_instance.boost_decay_time = bait.boost_time
	start_boost_tween(boost_instance)


func start_boost_tween(boost_instance: boost_data):
	var bost_tween: Tween = get_tree().create_tween()
	bost_tween.set_ease(Tween.EASE_IN)
	bost_tween.set_trans(Tween.TRANS_QUINT)
	bost_tween.tween_property(boost_instance, "boost_force", 0, boost_instance.boost_decay_time)
	bost_tween.connect("finished", Callable(self, "_on_boost_finished").bind(boost_instance))
	boost_instance.tween = bost_tween
	actual_boosts.append(boost_instance)


func _on_boost_finished(boost_instance: boost_data):
	boost_instance.tween.disconnect("finished", _on_boost_finished)
	boost_instance.tween = null
	actual_boosts.erase(boost_instance)



func update_boost_value():
	var boost_sum: float = 0
	for boost_data in actual_boosts:
		boost_sum += boost_data.boost_force
	bait.actual_boost = boost_sum
