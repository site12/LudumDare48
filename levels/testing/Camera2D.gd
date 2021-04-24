extends Camera2D


onready var player = get_tree().get_root().get_node("root/Mina")

func _physics_process(delta):
	global_position.x = player.global_position.x
