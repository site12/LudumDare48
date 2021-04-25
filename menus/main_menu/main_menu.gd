extends Control

var loaded = false
onready var ld = load("res://menus/loading/loading.tscn")



func start():
	if not loaded:
		var l = ld.instance()
		add_child(l)
		loaded = true
