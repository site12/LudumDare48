extends Control





func _on_Button_toggled(button_pressed):
	if !button_pressed:
		$AnimationPlayer.play_backwards("clicked")
		get_tree().get_root().get_node("main_menu").get_node("AnimationPlayer").play_backwards("options")
	else:
		$AnimationPlayer.play("clicked")
		get_tree().get_root().get_node("main_menu").get_node("AnimationPlayer").play("options")
