extends Control

var correct = [1, 2, 3, 4, 5, 6]
var order = []
var inRange = false
onready var highlight = get_tree().get_root().get_node("root/level/Bookshelf/Bookshelf_highlight")
onready var show = get_tree().get_root().get_node("root/UnderBookcaseDoor")
func _ready():
	pass # Replace with function body.

#adds the corresponding number to the book pulled (button pressed).
func _on_Button_pressed():
	order.append(1)
	if order.size() == 6:
		check_order()


func _on_Button2_pressed():
	order.append(2)
	if order.size() == 6:
		check_order()


func _on_Button3_pressed():
	order.append(3)
	if order.size() == 6:
		check_order()


func _on_Button4_pressed():
	order.append(4)
	if order.size() == 6:
		check_order()


func _on_Button5_pressed():
	order.append(5)
	if order.size() == 6:
		check_order()


func _on_Button6_pressed():
	order.append(6)
	if order.size() == 6:
		check_order()

#called when the order pressed is equal to the number of books pullable on the shelf,
#checks if the order is correct and then finishes the minigame if so.
#if wrong, clears the array so it can be added to again.
func check_order():
	if correct == order:
		get_parent().get_parent().get_node("Mina").canmove = true
		$Control/Light_Green.visible = true
		yield(get_tree().create_timer(2), "timeout")
		show.queue_free()
		self.visible = false
	else:
		order.clear()
		$Control/Light_Red.visible = true
		yield(get_tree().create_timer(2), "timeout")
		$Control/Light_Red.visible = false
		$Control/Button.pressed = false
		$Control/Button2.pressed = false
		$Control/Button3.pressed = false
		$Control/Button4.pressed = false
		$Control/Button5.pressed = false
		$Control/Button6.pressed = false

#exit button
func _on_Button7_pressed():
	self.visible = false
	order.clear()
	get_parent().get_parent().get_node("Mina").canmove = true

func _input(event):
	if Input.is_action_just_pressed("interact") and inRange:
		self.visible = true
		get_parent().get_parent().get_node("Mina").canmove = false

func _on_puzzle_body_entered(body):
	if body.name == 'Mina':
		highlight.visible = true
		inRange = true


func _on_puzzle_body_exited(body):
	if body.name == 'Mina':
		highlight.visible = false
		inRange = false

