extends RigidBody2D
var icicle_particle = load("res://ice layer/Misc Assets/Icicle Particle.tscn")


func _on_Icicle_body_entered(body):
	print(body.name)
	if body.name == 'player':
		body.die()
		queue_free()
	else:
		#spawn particles
		# var new_icicle_particle = icicle_particle.instance()
		# get_parent().add_child(new_icicle_particle)
		# new_icicle_particle.position = get_global_position()
		call_deferred('queue_free')
