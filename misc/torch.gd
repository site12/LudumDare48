extends AnimatedSprite
var _err

const MAX_BRIGHT = 2
const MIN_BRIGHT = 1
const DURATION = 2
onready var tween = $Tween
onready var light = $spiketh51

func _ready():
	randomize()
	new_tween()

func new_tween():
	tween.interpolate_property(light, "energy", light.energy, rand_range(MIN_BRIGHT, MAX_BRIGHT), rand_range(DURATION/2,DURATION), 9, 3)
	tween.start()

func _on_Tween_tween_all_completed():
	new_tween()
