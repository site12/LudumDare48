extends Node2D

var vector = Vector2.ZERO
var hit = false
var exists = true

func _process(delta):
	position += vector*delta*700

func take_damage(_damage):
	hit = true
	vector = -vector

func _on_damage_radius_body_entered(body):
	if exists:
		if body.name == "Mina":
			body.take_damage(30, self)

func _on_damage_radius_area_entered(area):
	if exists:
		if hit and area.name == "hit_box" and area.get_parent().name == "natas":
			area.get_parent().take_damage(50)
			exists = false
			queue_free()

func _on_Timer_timeout():
	exists = false
	queue_free()
