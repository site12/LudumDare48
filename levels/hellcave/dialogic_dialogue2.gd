extends Area2D


var begun = false
var good = false
onready var mina = get_parent().get_node("Mina")
onready var audio = get_tree().get_root().get_node("root/audio")
onready var parentnode = get_tree().get_root().get_node("root/speaker_pos/Control2")
onready var satan = preload("res://enemies/Hellcave/Natas/natass.tscn")

func after_dialog(timeline_name):
	mina.canmove = true
	audio.get_node("AnimationPlayer").play("fade_in")
	parentnode.queue_free()
	if good:
		get_parent().get_node('CanvasLayer/AnimationPlayer').play("fade")
		yield(get_tree().create_timer(2), "timeout")
		audio.get_node("AnimationPlayer").play_backwards("fade_in")
		get_tree().change_scene("res://menus/end/end.tscn")
	else:
		mina.toggle_hud()
		var natas = satan.instance()
		natas.position = get_parent().get_node("fake_natas").position
		natas.player = get_parent().get_node("Mina")
		natas.scale = Vector2(2,2)
		get_parent().get_node("fake_natas").queue_free()
		get_parent().add_child(natas)
		

func _on_dialogic_dialogue2_body_entered(body):
	if not begun and body.name == "Mina":
		var g2d = Dialogic.start("hell_end_bad")
		if Pizza.pieces() == 0:
			g2d = Dialogic.start("hell_end_good")
			good = true
			
		parentnode.add_child(g2d)
		mina.toggle_hud()
		begun = true
		audio.get_node("AnimationPlayer").play_backwards("fade_in")
		g2d.connect('timeline_end', self, 'after_dialog')
		yield(get_tree().create_timer(.2), "timeout")
		mina.canmove = false
		
		
