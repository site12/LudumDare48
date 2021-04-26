extends Control

func _ready():
	pass # Replace with function body.

var correct = ["snake", "bat", "bird"]
var order = []
onready var show = get_tree().get_root().get_node("root/BricksRevealBoss")


func _on_Button_pressed():
	order.append("bat")
	if order.size() == 3:
		check_order()

func check_order():
	if order == correct:
		$Control/Light_Green.visible = true
		yield(get_tree().create_timer(2), "timeout")
		show.queue_free()
		self.visible = false
	else:
		order.clear()
		$Control/Light_Red.visible = true
		yield(get_tree().create_timer(2), "timeout")
		$Control/Light_Red.visible = false
