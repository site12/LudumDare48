extends Area2D


var begun = false
onready var mina = get_parent().get_node("Mina")
onready var audio = get_tree().get_root().get_node("root/audio")
onready var parentnode = get_tree().get_root().get_node("root/speaker_pos/Control2")

func after_dialog(timeline_name):
	mina.canmove = true
	mina.toggle_hud()
	audio.get_node("AnimationPlayer").play("fade_in")
	parentnode.queue_free()

func _on_dialogic_dialogue2_body_entered(body):
	if not begun and body.name == "Mina":
		var g2d = Dialogic.start("hell_end_bad")
		if Pizza.pieces() == 0:
			g2d = Dialogic.start("hell_end_good")
			
		parentnode.add_child(g2d)
		mina.toggle_hud()
		begun = true
		audio.get_node("AnimationPlayer").play_backwards("fade_in")
		g2d.connect('timeline_end', self, 'after_dialog')
		yield(get_tree().create_timer(.2), "timeout")
		mina.canmove = false
		
