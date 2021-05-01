extends Node2D
var _err

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Pizza.location = "dungeon"
	$CanvasLayer3/Control/ProgressBar.max_value = $bigslime.health
	_err = $bigslime.connect("im_dead", $level/Hells_Gate, "reveal_door")
	_err = $bigslime.connect("im_injured", $CanvasLayer3/Control, "update_health")

