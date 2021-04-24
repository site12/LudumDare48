extends Area2D

var _err

func _ready():
	_err = connect('body_entered', self, '_on_vines_body_entered')
	_err = connect('body_exited', self, '_on_vines_body_exited')

func _on_vines_body_entered(body):
	if body.name == 'player':
		body.on_vines = true

func _on_vines_body_exited(body):
	if body.name == 'player':
		body.on_vines = false