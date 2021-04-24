extends Node2D

var icicle_scene = preload('res://ice layer/Icicle.tscn')

func _on_Area2D_body_entered(_body):
	if $icicle_sprite.visible == true:
		var icicle = icicle_scene.instance()
		icicle.position = position
		$icicle_sprite.visible = false
		get_parent().call_deferred('add_child', icicle)
		icicle.contact_monitor = true
		$icicle_timer.start()

func _on_Timer_timeout():
	$icicle_sprite.visible = true
