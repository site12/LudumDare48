extends Control





func _on_Button_toggled(button_pressed):
	if !button_pressed:
		$AnimationPlayer.play_backwards("clicked")
		get_parent().get_parent().get_parent().get_parent().get_node("AnimationPlayer").play_backwards("options")
	else:
		$AnimationPlayer.play("clicked")
		get_parent().get_parent().get_parent().get_parent().get_node("AnimationPlayer").play("options")
