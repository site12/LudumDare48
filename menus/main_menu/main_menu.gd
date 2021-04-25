extends Control

var loaded = false
onready var ld = load("res://menus/loading/loading.tscn")



func start():
	if not loaded:
		var l = ld.instance()
		add_child(l)
		loaded = true
		yield(get_tree().create_timer(3), "timeout")
		get_tree().change_scene("res://levels/library/library.tscn")
