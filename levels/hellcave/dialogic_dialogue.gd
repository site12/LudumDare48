extends Area2D


var begun = false
onready var mina = get_parent().get_node("Mina")
onready var audio = get_tree().get_root().get_node("root/audio")
onready var parentnode = get_tree().get_root().get_node("root/speaker_pos/Control")
func _on_dialogic_dialogue_body_entered(body):
	if not begun and body.name == "Mina":
		
		var gd = Dialogic.start("hellcave")
		parentnode.add_child(gd)
		parentnode.get_parent().get_node("AnimatedSprite").visible = true
		begun = true
		
		gd.connect('timeline_end', self, 'after_dialog')
		yield(get_tree().create_timer(.2), "timeout")
		mina.canmove = false

func after_dialog(timeline_name):
	mina.canmove = true
	mina.toggle_hud()
	audio.get_node("AnimationPlayer").play("fade_in")
	parentnode.get_parent().get_node("AnimatedSprite").queue_free()
	parentnode.queue_free()
