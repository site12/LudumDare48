extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_toggled(button_pressed):
	if !button_pressed:
		$AnimationPlayer.play_backwards("clicked")
		get_tree().get_root().get_node("main_menu").get_node("AnimationPlayer").play_backwards("site12")
	else:
		$AnimationPlayer.play("clicked")
		get_tree().get_root().get_node("main_menu").get_node("AnimationPlayer").play("site12")
