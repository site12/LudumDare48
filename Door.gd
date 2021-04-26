extends Sprite

export var next_scene = "res://menus/main_menu/main_menu.tscn"

func _on_Area2D_body_entered(body):
	if body.name == "Mina":
		$Doorhighlight.visible = true

func _on_Area2D_body_exited(body):
	if body.name == "Mina":
		$Doorhighlight.visible = false
