extends Sprite

export var next_scene = "res://menus/main_menu/main_menu.tscn"
var player_in_area = false
func _on_Area2D_body_entered(body):
	if body.name == "Mina":
		$Doorhighlight.visible = true
		player_in_area = true

func _on_Area2D_body_exited(body):
	if body.name == "Mina":
		$Doorhighlight.visible = false
		player_in_area = false

func _process(_delta):
	if player_in_area:
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene(next_scene)

func reveal_door():
	visible = true
	$Area2D.monitoring = true