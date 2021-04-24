extends KinematicBody2D

const UP = Vector2(0, -1)
var GRAVITY = 9.8 *500
var ACCELERATION = 75
var FRICTION = 1
const MAX_SPEED = 700*1.5
const JUMP_HEIGHT = -1500 *1.4
const MIN_JUMP_HEIGHT = -500*2


var motion = Vector2()
var grabbing = false
var jumping = false
var sliding = false
var vining = false
var canmove = true
var on_ice = false
var on_vines = false
var dir = 1
var on_wall = false
var which_wall = 0
var jump_particle = load("res://land.tscn")
var current_zone = 'village'
var has_pick = false
var has_machete = false
onready var jt = $jump_timer
onready var camerapos = $camerapos
onready var camera = $camerapos/Camera2D
onready var root = get_tree().get_root().get_node('root')


func _physics_process(delta):
	on_wall = $Right.is_colliding() || $Left.is_colliding() || $TopRight.is_colliding() || $TopLeft.is_colliding()
	if $Right.is_colliding() || $TopRight.is_colliding():
		which_wall = -1
	if $Left.is_colliding() || $TopLeft.is_colliding():
		which_wall = 1
	# print(str(on_wall))
	motion.y += GRAVITY*delta
	var friction = false
	movement(friction)
	direction()
	slide(delta)
	motion = move_and_slide(motion, UP)
func slide(delta):
	if on_vines and Input.is_action_pressed("grab"):
		vining = true
		on_wall = true
		if motion.y >0 and vining:
			print("grabbed")
			motion.y = 0 + Input.get_action_strength("down")*500 - Input.get_action_strength("up")*500
			motion.x = 0 + Input.get_action_strength("right")*500 - Input.get_action_strength("left")*500
	else:
		vining = false
	if on_wall and Input.is_action_pressed("grab"):
		sliding = true
		if motion.y >0:
			motion.y += (-GRAVITY+200)*delta
	else:
		sliding = false
	
func direction():
	if dir == 1 and motion.x == 0:
		$AnimatedSprite.flip_h = true
		if !jumping:
			$AnimatedSprite.play("idle")

		elif !sliding:
			$AnimatedSprite.play("jump")

		elif vining:
			$AnimatedSprite.play("slide")

		else:
			$AnimatedSprite.play("slide")


	elif dir == 1:
		$AnimatedSprite.flip_h = true
		if !jumping:
			$AnimatedSprite.play("run")

		elif !sliding:
			$AnimatedSprite.play("jump")

		elif vining:
			$AnimatedSprite.play("slide")

		else:
			$AnimatedSprite.play("slide")


	if dir == -1 and motion.x == 0:
		# $RayCast2D.scale.x = 1
		$AnimatedSprite.flip_h = false
		if !jumping:
			$AnimatedSprite.play("idle")

		elif !sliding:
			$AnimatedSprite.play("jump")

		elif vining:
			$AnimatedSprite.play("slide")

		else:
			$AnimatedSprite.play("slide")


	elif dir == -1:
		$AnimatedSprite.flip_h = false
		if !jumping:
			$AnimatedSprite.play("run")

		elif !sliding:
			$AnimatedSprite.play("jump")

		elif vining:
			$AnimatedSprite.play("slide")

		else:
			$AnimatedSprite.play("slide")

		
func movement(friction):
	if is_on_floor():
		if jumping:
			var new_jump_particle = jump_particle.instance()
			get_parent().add_child(new_jump_particle)
			new_jump_particle.position = $jump_position.get_global_position()
		jumping = false
		pass
	else:
		jumping = true

	if Input.is_action_just_released("jump") and motion.y < 0:
		motion.y = lerp(motion.y, 0, 0.5)
	
	if canmove:
		### Left and right
		if Input.is_action_pressed("right"):
			
			if not on_ice and motion.x < 0 and is_on_floor():
				
				motion.x = lerp(motion.x, 0, 0.5)
				
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			
			dir = -1
			
		
		elif Input.is_action_pressed("left"):
			
			if not on_ice and motion.x > 0 and is_on_floor():
				
				motion.x = lerp(motion.x, 0, 0.5)
				
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			
			dir = 1

		else:
			friction = true
	
	#jump
	if is_on_floor() and canmove or vining:
		
		
		if Input.is_action_just_pressed("jump"):
			
			# GRAVITY = 9.8 * 500
			# $jump_timer.s tart()
			motion.y += JUMP_HEIGHT
			var new_jump_particle = jump_particle.instance()
			get_parent().add_child(new_jump_particle)
			new_jump_particle.position = $jump_position.get_global_position()
		if friction == true and not on_ice:
			motion.x = lerp(motion.x, 0, FRICTION)
	
	elif on_wall and canmove:
		
		# if on_ice:
		# 	motion.y += (GRAVITY*0.01)
		if Input.is_action_just_pressed("jump") and not on_ice:


			# GRAVITY = 9.8 * 500
			# $jump_timer.start()
			# $particles/wall_jump.emitting = true
			var motion_change =  (6 * Vector2(256,-256))#$RayCast2D/Sprite.position)
			print(dir)
			motion_change.x *= which_wall
			var new_jump_particle = jump_particle.instance()
			get_parent().add_child(new_jump_particle)
			match which_wall:
				-1:
					new_jump_particle.position = $right_wall_jump_position.get_global_position()
				1:
					new_jump_particle.position = $left_wall_jump_position.get_global_position()

			motion = motion_change
			print(motion_change)
			
	else:
		pass

func die():
	canmove = false

func _on_jump_timer_timeout():
	if Input.is_action_pressed('jump'):
		GRAVITY = 9.8 * 250
	else:
		GRAVITY = 9.8 * 1000

func pass_camera_shake(amount):
	camera.add_trauma(amount)


