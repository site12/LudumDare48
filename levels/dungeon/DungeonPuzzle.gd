extends Control

func _ready():
	pass # Replace with function body.

var correct = ["snake", "bat", "bird"]
var order = []
onready var show = get_parent().get_parent().get_node("level/BricksRevealBoss")
var inRange = false

func _on_Button_pressed():
	order.append("bat")
	if order.size() == 3:
		check_order()

func _on_Button2_pressed():
	order.append("snake")
	if order.size() == 3:
		check_order()

func _on_Button3_pressed():
	order.append("bird")
	if order.size() == 3:
		check_order()

func check_order():
	if order == correct:
		$Control/Light_Green.visible = true
		yield(get_tree().create_timer(2), "timeout")
		show.queue_free()
		self.visible = false
		get_parent().get_parent().get_node("Mina").canmove = true
	else:
		order.clear()
		$Control/Light_Red.visible = true
		yield(get_tree().create_timer(2), "timeout")
		$Control/Light_Red.visible = false
		$Control/Button.pressed = false
		$Control/Button2.pressed = false
		$Control/Button3.pressed = false


func _on_Button4_pressed():
	self.visible = false
	order.clear()
	get_parent().get_parent().get_node("Mina").canmove = true

func _input(event):
	if Input.is_action_just_pressed("interact") and inRange:
		self.visible = true
		get_parent().get_parent().get_node("Mina").canmove = false

func _on_puzzle_body_entered(body):
	if body.name == 'Mina':
		inRange = true

func _on_puzzle_body_exited(body):
	inRange = false
