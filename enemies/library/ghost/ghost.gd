extends KinematicBody2D

var run_speed = 100
var velocity = Vector2.ZERO
var health = 45
var player = null
var knockback = 50
var dead = false


func _physics_process(_delta):
	velocity = Vector2.ZERO
	if player:
		velocity += position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)
	if velocity.x <=0:
		$AnimatedSprite.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = false
		
	$hud/ProgressBar.value = health

func _on_line_of_sight_body_entered(body):
	if body.name == "Mina" and not dead:
		player = body

func _on_line_of_sight_body_exited(body):
	if body.name == "Mina" and not dead:
		player = null

func take_damage(dmg):
	if not dead:
		$audio/AudioStreamPlayer.play()
	print("took damage")
	health = health - dmg
	$AnimationPlayer.play("took_damage")
	if $AnimatedSprite.flip_h == true:
		position.x += knockback
		velocity = Vector2.ZERO
	if $AnimatedSprite.flip_h == false:
		position.x -= knockback
		velocity = Vector2.ZERO
	if health <=0:
		die()

func die():
	dead = true
	self.visible = false


func _on_damage_radius_body_entered(body):
	if body == player and not dead:
		body.take_damage(50, self)
		#make player take damage based on time spent in zone
