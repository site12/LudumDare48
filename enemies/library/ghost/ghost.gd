extends KinematicBody2D

var run_speed = 65
var velocity = Vector2.ZERO
var health = 45
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)
	
	if velocity.x >= 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
		

func _on_line_of_sight_body_entered(body):
	if body.name == "Mina":
		player = body

func _on_line_of_sight_body_exited(body):
	player = null

func take_damage(dmg):
	health = health - dmg
	if health <=0:
		die()

func die():
	self.queue_free()


func _on_damage_radius_body_entered(body):
	if body == player:
		pass
		#player takes damage based on time spent in zone
