extends Node2D

func _ready():
	$AnimationPlayer.play("wheels")

func _physics_process(delta):
	$Camera2D.position.x +=1
	$Node2D/Sprite.position.x +=1
	$ParallaxBackground/ParallaxLayer2/AnimatedSprite.position.x+=0.3
	


func _on_Timer_timeout():
	randomize()
	$ParallaxBackground/ParallaxLayer2/AnimatedSprite.visible = true
	yield(get_tree().create_timer(.1), "timeout")
	$ParallaxBackground/ParallaxLayer2/AnimatedSprite.visible = false
	$Timer.wait_time = rand_range(3,5)
