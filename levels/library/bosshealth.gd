extends Control


#onready var boss = get_tree().get_root().get_node("root/bigknight")

func _physics_process(delta):
	#$ProgressBar.value = boss.health
	#if boss.health <=0:
	#	self.queue_free()
	pass
