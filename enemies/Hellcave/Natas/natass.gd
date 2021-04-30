extends KinematicBody2D

const JUMP_HEIGHT = -200
const MAX_SPEED = 100
const ACCELERATION = 25
const GRAVITY = 9.8 *300
var run_speed = 10
var velocity = Vector2.ZERO
var dir_to_player
var health = 600
var player = null
export var canmove = true
var knockback = 50
var state_machine :AnimationNodeStateMachinePlayback
var orbit
onready var fireball = preload("res://fireball.tscn")

signal im_dead
signal im_injured

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	var boss_entrance = get_parent().get_node("BossEntrance")
	if boss_entrance:
		boss_entrance.connect("player_entered", self, "_on_player_entered")
	orbit = get_parent().get_node("Position2D")

func _physics_process(delta):
	var current = state_machine.get_current_node()
	# velocity = Vector2.ZERO
	if Input.is_action_just_pressed("ui_accept"):
		attack()
	if player:
		if get_global_position().x < player.get_global_position().x:
			dir_to_player = +1
		else:
			dir_to_player = -1

		if canmove:


			velocity += (position.direction_to(player.position) + position.direction_to(orbit.position)) * run_speed
			velocity = velocity.clamped(200)
			# velocity = move_and_slide(velocity)
			if velocity.x <=0:
				$AnimatedSprite.flip_h = true
			elif velocity.x > 0:
				$AnimatedSprite.flip_h = false

	velocity = move_and_slide(velocity)

func is_on_down():
	return $down.is_colliding()


func take_damage(dmg):
	print("took damage")
	health = health - dmg
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
	#self.queue_free() // this made it not able to get to the end scene :(
	get_parent().get_node('CanvasLayer/AnimationPlayer').play("fade")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().get_root().get_node("root/audio").get_node("AnimationPlayer").play_backwards("fade_in")
	get_tree().change_scene("res://menus/end/end.tscn")

func _on_player_entered(playerwhoentered):
	player = playerwhoentered
	$fireball_timer.start()


func attack():
	if player:
		state_machine.travel("fire")
		var send_it = fireball.instance()
		send_it.position = position
		send_it.vector = position.direction_to(player.position)
		get_parent().add_child(send_it)



func _on_damage_radius_body_entered(body):
	pass


func _on_target_zone_body_entered(body):
	pass


func _on_smack_box_body_entered(body):
	if body.name == "Mina":
		body.take_damage(70, self)


func _on_right_target_zone_body_entered(body):
	if body.name == "Mina" and is_on_down():
		canmove = false
		state_machine.travel("jump")
		velocity.x = 500
		velocity.y = -1000


func _on_left_target_zone_body_entered(body):
	if body.name == "Mina" and is_on_down():
		canmove = false
		state_machine.travel("jump")
		velocity.x = -500
		velocity.y = -1000

func _on_fireball_timer_timeout():
	attack()
	$fireball_timer.wait_time = rand_range(0.833,1.5)
	$fireball_timer.start()
