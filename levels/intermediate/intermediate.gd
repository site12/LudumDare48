extends Node2D

var stop = false

var loading = load("res://menus/loading/loading.tscn")

func _ready():
	$AnimationPlayer.play("wheels")
	yield(get_tree().create_timer(5), "timeout")
	$AnimationPlayer.stop()
	stop = true
	get_parent().get_node("AnimatedSprite").visible = true
	get_parent().get_node("AnimationPlayer").play("run in")
	yield(get_tree().create_timer(3), "timeout")
	var l = loading.instance()
	add_child(l)
	yield(get_tree().create_timer(5), "timeout")
	var err = get_tree().change_scene("res://levels/library/library.tscn")
	stop = true
	

func _physics_process(delta):
	if not stop:
		$Camera2D.position.x +=1
		$Node2D/Sprite.position.x +=1
		$ParallaxBackground/ParallaxLayer2/AnimatedSprite.position.x+=0.3
	



