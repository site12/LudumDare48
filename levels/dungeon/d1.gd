extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Pizza.location = "dungeon"
	$bigslime.connect("im_dead", $level/Hells_Gate, "reveal_door")


