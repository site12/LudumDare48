extends Node2D


var platform3 = preload('res://city layer/Misc Assets/Platform3.tscn')
var platform2 = preload('res://city layer/Misc Assets/Platform2.tscn')
var platform1 = preload('res://city layer/Misc Assets/Platform1.tscn')
export var platform_type = 'platform3'
var is_platform = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var new_platform
	# $AnimationPlayer.play_backwards("die")
	match platform_type:
		'platform3':
			new_platform = platform3.instance()
		'platform2':
			new_platform = platform2.instance()
		'platform1':
			new_platform = platform1.instance()
	# new_platform.position.y = 500
	add_child(new_platform)
	is_platform = true


func _on_Area2D_body_entered(body):
	if is_platform and body.name == "player":
		$AnimationPlayer.play("die")
		is_platform = false
