extends Control





func _on_Button_pressed():
	get_tree().get_root().get_node("main_menu").start()
