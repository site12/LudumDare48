extends Area2D
signal player_entered

func _on_BossEntrance_body_entered(body):
	if body.name == "Mina":
		get_parent().get_node("BossCamera").current = true
		emit_signal("player_entered", body)