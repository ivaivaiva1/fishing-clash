extends Node

func _ready() -> void:
	randomize()


## musics 
#const LAVA_MUSIC := {"stream": preload("uid://dad5yqmo2357y"), "volume": -12.0}


# effects 
const COIN_BRACKEYS := {"stream": preload("uid://chy02xnx2np1"), "volume": -6.0}
const FIGHTSTICK_CLICK := {"stream": preload("uid://0bhujr4xcvjc"), "volume": -20.0}
const BUBBLE01_SFX := {"stream": preload("uid://yu67vxfw0gr8"), "volume": 2.0}
const BUBBLE02_SFX := {"stream": preload("uid://dqq31jsm4l4wx"), "volume": 2.0}
const BUBBLE03_SFX := {"stream": preload("uid://bypta7trk67me"), "volume": 6.0}
const BUBBLE04_SFX := {"stream": preload("uid://bg1h11vxu5nrm"), "volume": 4.0}


var _last_bubble: Dictionary = {}
func get_random_bubble() -> Dictionary:
	var options = [BUBBLE01_SFX, BUBBLE02_SFX, BUBBLE03_SFX, BUBBLE04_SFX]
	
	var choice: Dictionary = options.pick_random()
	while choice == _last_bubble:
		choice = options.pick_random()
	
	_last_bubble = choice
	return choice
