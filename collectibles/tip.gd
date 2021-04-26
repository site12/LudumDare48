extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("woot")


func _on_Area2D_body_entered(body):
	if body.name == "Mina":
		$Area2D.queue_free()
		$img.visible = false
		$Light2D.visible = false
		$audio/AudioStreamPlayer.play()
