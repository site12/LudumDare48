extends KinematicBody2D

const JUMP_HEIGHT = -200
const MAX_SPEED = 200
const ACCELERATION = 25
const GRAVITY = 9.8 *300
var run_speed = 65
var velocity = Vector2.ZERO
var dir_to_player
var health = 60
var player = null
export var canmove = true
var knockback = 50
var state_machine :AnimationNodeStateMachinePlayback

signal im_dead
signal im_injured

var dead = false

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	var current = state_machine.get_current_node()
	# velocity = Vector2.ZERO
	if player:
		if get_global_position().x < player.get_global_position().x:
			dir_to_player = +1
		else:
			dir_to_player = -1
		# var player_distance = get_global_position().x - player.get_global_position().x
		# if player_distance < 0:
		# 	dir_to_player = -1
		# else:
		# 	dir_to_player = 1
		if canmove:

			match dir_to_player:
				1:
					velocity.x = min(velocity.x + (ACCELERATION*dir_to_player), MAX_SPEED)
				-1:
					velocity.x = max(velocity.x + (ACCELERATION*dir_to_player), MAX_SPEED*-1)
		# velocity.x = (velocity.x + (200*dir_to_player))
		# velocity += position.direction_to(player.position) * run_speed
		else:
			velocity.x = 0
	velocity.y += GRAVITY*delta
	if player:
		if dir_to_player > 0:
			if $right.is_colliding() and is_on_down() and $right.get_collider().name != "Mina" and not $topright.is_colliding():
				velocity.x = 0
				velocity.y += JUMP_HEIGHT
		if dir_to_player < 0:
			if $left.is_colliding()  and is_on_down() and $left.get_collider().name != "Mina" and not $topleft.is_colliding():
				velocity.x = 0
				velocity.y += JUMP_HEIGHT

	if velocity.x != 0:
		if current != "walking":
			state_machine.travel("walking")
	else:
		if current != "idle":
			state_machine.travel("idle")
	velocity = move_and_slide(velocity)
	if velocity.x <0:
		$Sprite.flip_h = true
		$target_zone.scale.x = -1
		$smack_box.scale.x = -1
	elif velocity.x > 0:
		$Sprite.flip_h = false
		$target_zone.scale.x = 1
		$smack_box.scale.x = 1
	elif velocity.x == 0:
		match dir_to_player:
			1:
				$Sprite.flip_h = false
				$target_zone.scale.x = 1
				$smack_box.scale.x = 1
			-1:
				$Sprite.flip_h = true
				$target_zone.scale.x = -1
				$smack_box.scale.x = -1


func _on_line_of_sight_body_entered(body):
	if body.name == "Mina":
		player = body

func is_on_down():
	return $down.is_colliding()

func _on_line_of_sight_body_exited(body):
	if body.name == 'Mina':
		player = null

func take_damage(dmg):
	
	if not dead:
		$audio/AudioStreamPlayer.play()
	print("took damage")
	health = health - dmg
	$hud/ProgressBar.value = health
	emit_signal("im_injured", health)
	$DamageAnimation.play("took_damage")
	if $Sprite.flip_h == true:
		position.x += knockback
		velocity = Vector2.ZERO
	if $Sprite.flip_h == false:
		position.x -= knockback
		velocity = Vector2.ZERO
	if health <=0:
		die()

func die():
	emit_signal("im_dead")
	self.visible = false
	dead = true
	yield(get_tree().create_timer(.5), "timeout")
	self.queue_free()

func _on_player_entered(playerwhoentered):
	player = playerwhoentered


func attack():
	print("this man swinging")
	state_machine.travel('swing')
	# canmove = false
	# yield(get_tree().create_timer(.1), "timeout")
	# canmove = true


func _on_damage_radius_body_entered(body):
	if body.name == "Mina" and not dead:
		body.take_damage(10, self)
		#make player take damage based on time spent in zone

func _on_target_zone_body_entered(body):
	if body.name == "Mina" and not dead:
		attack()

func _on_smack_box_body_entered(body):
	if body.name == "Mina" and not dead:
		body.take_damage(45, self)
