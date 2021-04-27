extends Node2D
var _err

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Pizza.location = "library"
	$CanvasLayer3/bosshealth/ProgressBar.max_value = $bigknight.health
	_err = $bigknight.connect("im_dead", $Door, "reveal_door")
	_err = $bigknight.connect("im_injured", $CanvasLayer3/bosshealth, "update_health")
