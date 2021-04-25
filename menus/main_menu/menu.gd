extends Node2D

func _ready():
	$AnimationPlayer.play("wheels")

func _physics_process(delta):
	$Camera2D.position.x +=1
	$Node2D/Sprite.position.x +=1
