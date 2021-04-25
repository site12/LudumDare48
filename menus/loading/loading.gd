extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var time_spent = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("begin")
	yield(get_tree().create_timer(time_spent), "timeout")
	$AnimationPlayer.play_backwards("begin")
		
