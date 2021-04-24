extends KinematicBody2D

const UP = Vector2(0, -1)
var GRAVITY = 9.8 *300
var ACCELERATION = 50
var FRICTION = 1
const MAX_SPEED = 500
const JUMP_HEIGHT = -1300
const MIN_JUMP_HEIGHT = -750


var motion = Vector2()
var grabbing = false
var jumping = false
var sliding = false
var climbing = false
var falling = false
var canmove = true
var on_ice = false
var on_ladder = false
var dir = 1
var on_wall = false
var which_wall = 0
var current_attack = "none"
#var jump_particle = load("res://land.tscn")
var state_machine :AnimationNodeStateMachinePlayback
onready var jt = $'jump_timer'
#onready var camerapos = $camerapos
#onready var camera = $camerapos/Camera2D
onready var root = get_tree().get_root().get_node('root')

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
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
		-1:
			$Sprite.flip_h = false
		

func movement(friction):
	var current = state_machine.get_current_node()

	if Input.is_action_just_pressed("attack_1"):

		if current != "punch1" and current != "punch2" and current != "kick":
			state_machine.travel("punch1")

		elif current == "punch1":
			state_machine.travel("punch2")

		elif current == "punch2":
			state_machine.travel("kick")



	

	if Input.is_action_just_pressed("down"):
		set_collision_mask_bit(1, false)
	if Input.is_action_just_released("down"):
		set_collision_mask_bit(1, true)
	
	if Input.is_action_just_released("jump") and motion.y < 0:
		motion.y = lerp(motion.y, 0, 0.5)	
	if current != "punch1" and current != "punch2" and current != "kick":
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
	else:
		motion.x = lerp(motion.x, 0, FRICTION)

	if is_on_floor() and canmove or climbing: 

		if Input.is_action_just_pressed("jump"):
			state_machine.travel("jump")
			motion.y += JUMP_HEIGHT

		if friction == true and not on_ice:
			motion.x = lerp(motion.x, 0, FRICTION)

	if current != "punch1" and current != "punch2" and current != "kick":
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

func die():
	canmove = false
	state_machine.travel("dead")
	set_physics_process(false)

func _on_jump_timer_timeout():
	if Input.is_action_pressed('jump'):
		GRAVITY = 9.8 * 250
	else:
		GRAVITY = 9.8 * 1000

func set_attack(attack):
	current_attack = attack

#func pass_camera_shake(amount):
#	camera.add_trauma(amount)


