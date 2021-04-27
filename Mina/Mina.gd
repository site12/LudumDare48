extends KinematicBody2D

const UP = Vector2(0, -1)
var GRAVITY = 9.8 *300
var ACCELERATION = 25
var FRICTION = 1
const MAX_SPEED = 500
const JUMP_HEIGHT = -1300
const MIN_JUMP_HEIGHT = -350

var shown = false
var motion = Vector2()
var grabbing = false
var jumping = false
var sliding = false
var climbing = false
var falling = false
export var canmove = true
var on_ice = false
var on_ladder = false
var invincible = false
var dir = 1
var health = Pizza.healthy()
var on_wall = false
var which_wall = 0
var current_attack = "none"
var speed_mod = 1
var slimey
#var jump_particle = load("res://land.tscn")
var state_machine :AnimationNodeStateMachinePlayback
var locked = false
onready var jt = $'jump_timer'
#onready var camerapos = $camerapos
#onready var camera = $camerapos/Camera2D
onready var root = get_tree().get_root().get_node('root')

export var camera = true

func toggle_hud():
	$CanvasLayer/Control.visible = !$CanvasLayer/Control.visible

func _ready():
	if camera:
		$Position2D/Camera2D.current = true
	else:
		$Position2D/Camera2D.current = false
	state_machine = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	pizza()
	score()
	$CanvasLayer/Control/ProgressBar.value = health
	if health < 200:
		if not shown:
			$CanvasLayer/AnimationPlayer.play("show")
			shown = true
			print(shown)
		
		
	on_wall = $Right.is_colliding() || $Left.is_colliding() || $TopRight.is_colliding() || $TopLeft.is_colliding()
	if $Right.is_colliding() || $TopRight.is_colliding():
		which_wall = -1
	if $Left.is_colliding() || $TopLeft.is_colliding():
		which_wall = 1
	# print(str(on_wall))
	motion.y += GRAVITY*delta
	var friction = false
	if not locked:
		if canmove:
			movement(friction)
		direction()
		slide(delta)
		motion = move_and_slide(motion, UP)
func slide(delta):
	# if on_ladder and Input.is_action_pressed("grab"):
	# 	climbing = true
	# 	on_wall = true
	# 	if motion.y >0 and climbing:
	# 		print("grabbed")
	# 		motion.y = 0 + Input.get_action_strength("down")*500 - Input.get_action_strength("up")*500
	# 		motion.x = 0 + Input.get_action_strength("right")*500 - Input.get_action_strength("left")*500
	# else:
	# 	climbing = false
	# if on_wall and Input.is_action_pressed("grab"):
	# 	sliding = true
	# 	if motion.y >0:
	# 		motion.y += (-GRAVITY+200)*delta
	# else:
	# 	sliding = false
	sliding = false
	
func direction():
	match dir:
		1:
			$Sprite.flip_h = true
			$Position2D.scale.x = 1
			$Sprite/smackbox.scale.x = -1
		-1:
			$Sprite.flip_h = false
			$Position2D.scale.x = -1
			$Sprite/smackbox.scale.x = 1
		

func movement(friction):
	var current = state_machine.get_current_node()
	speed_mod = 1

	if current == 'falling' and ray_on_floor():
		if ($down.is_colliding() and $down.get_collider().name == "Floor") or ($down2.is_colliding() and $down2.get_collider().name == "Floor"):
			$Audio/land.play()

	if slimey:
		var bodies = slimey.get_node("damage_radius").get_overlapping_bodies()
		for body in bodies:
			if body == self:
				speed_mod = 0.5

	if Input.is_action_just_pressed("attack_1"):

		if current != "punch1" and current != "punch2" and current != "kick":
			state_machine.travel("punch1")

		elif current == "punch1":
			state_machine.travel("punch2")

		elif current == "punch2":
			state_machine.travel("kick")

	if current == "roll":
		motion.x = 500 * -dir
	else:
		if get_collision_mask_bit(2) == false:
			set_collision_mask_bit(2, true)

	if Input.is_action_just_pressed("down"):
		set_collision_mask_bit(1, false)
	if Input.is_action_just_released("down"):
		set_collision_mask_bit(1, true)
	
	if Input.is_action_just_released("jump") and motion.y < 0:
		motion.y = lerp(motion.y, 0, 0.5)	


	if Input.is_action_just_pressed("roll"):
		set_collision_mask_bit(2, false)
		state_machine.travel("roll")
		current = "roll"

	if current != "punch1" and current != "punch2" and current != "kick" and current != 'roll':
		if canmove:
			if Input.is_action_pressed("right"):
				if current != "roll" or dir == 1:
					if not on_ice and motion.x < 0 and is_on_floor():
							
						motion.x = lerp(motion.x, 0, 0.2)
						
					motion.x = min(motion.x+ACCELERATION, MAX_SPEED*speed_mod)
					# if current == "roll":
					# 	state_machine.travel("run")
					dir = -1
			elif Input.is_action_pressed("left"):
				if current != "roll" or dir == -1:
					if not on_ice and motion.x > 0 and is_on_floor():
						
						motion.x = lerp(motion.x, 0, 0.2)
						
					motion.x = max(motion.x-ACCELERATION, -MAX_SPEED*speed_mod)
					# if current == "roll":
					# 	state_machine.travel("run")
					dir = 1
			else:
				if current != "roll":
					friction = true
	elif current != "roll":
		motion.x = lerp(motion.x, 0, FRICTION)

	if is_on_floor() and (canmove or climbing): 

		if Input.is_action_just_pressed("jump"):
			$Audio/jump.play()
			state_machine.travel("jump")
			motion.y += JUMP_HEIGHT

		if friction == true and not on_ice:
			motion.x = lerp(motion.x, 0, FRICTION)

	if current != "punch1" and current != "punch2" and current != "kick" and current != "roll":
		if motion.y > 100 and not ray_on_floor():
			state_machine.travel("falling")
		elif motion.y < 48:
			state_machine.travel("jump")
		elif motion.x != 0 and current != "run":
			state_machine.travel("run")
		elif ray_on_floor() and motion.x == 0 and current != "idle":
			state_machine.travel("idle")



func ray_on_floor():
	return $down.is_colliding() or $down2.is_colliding()

func take_damage(damage, source):
	if state_machine.get_current_node() != "roll":
		print("yeaowch " + str(damage))
		var knockback_vector= Vector2.ZERO
		if get_global_position() < source.get_global_position():
			knockback_vector.x = -500
		else:
			knockback_vector.x = 500
		knockback_vector.y = -500
		# var angle_to_baddie = get_global_position().angle_to(source.get_global_position())
		# print("angle to baddie: " + str(angle_to_baddie))
		# var vector_angle = Vector2(cos(angle_to_baddie), sin(angle_to_baddie))
		# vector_angle.x *= 1
		# vector_angle.y = -abs(vector_angle.y)
		motion = knockback_vector
		print("motion: " + str(motion))
		Pizza.adjust_health(damage)
		health = Pizza.healthy()
		$EffectAnimations.play("took_damage")
		state_machine.travel("hurt")
		if health <= 0:
			die()

func die():
	# canmove = false
	Pizza.adjust_health(200)
	$CanvasLayer/Control/ProgressBar.value = health
	state_machine.travel("dead")
	set_physics_process(false)
	yield(get_tree().create_timer(2), "timeout")
	Pizza.health = 200
	Pizza.tipmoney = 0
	if Pizza.location == "library":
		get_tree().change_scene("res://levels/library/library.tscn")
	elif Pizza.location == "dungeon":
		get_tree().change_scene("res://levels/dungeon/dungeon.tscn")
	elif Pizza.location == "hellcave":
		get_tree().change_scene("res://levels/hellcave/hellcave.tscn")
	

func _on_jump_timer_timeout():
	if Input.is_action_pressed('jump'):
		GRAVITY = 9.8 * 250
	else:
		GRAVITY = 9.8 * 1000

func set_attack(attack):
	current_attack = attack

func _on_smackbox_area_entered(area):
	print("area_entered")
	if area.name == "hit_box":
		print("name checks out")
		var enemy = area.get_parent()
		if enemy.is_in_group("baddies"):
			print("is baddie")
			var damage_dealt
			match current_attack:
				"punch1":
					damage_dealt = 20
				"punch2":
					damage_dealt = 25
				"kick":
					damage_dealt = 40
				_:
					damage_dealt = 0
			enemy.take_damage(damage_dealt)

func _on_i_frame_timer_timeout():
	invincible = true

func i_frame_over():
	invincible = false

func pizza():
	$CanvasLayer/Control/AnimatedSprite.frame = Pizza.pieces()
	if Input.is_action_just_pressed("pizza"):
		Pizza.eat()
		health = Pizza.healthy()
	if Pizza.pieces() == 6:
		$CanvasLayer/Control/AnimatedSprite.visible = false

func score():
	$CanvasLayer/Control/Label2.text = "Tip Jar: $" + str(Pizza.tipmoney + Pizza.totalmoney)

#func pass_camera_shake(amount):
#	camera.add_trauma(amount)


