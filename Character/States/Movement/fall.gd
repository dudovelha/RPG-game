extends "res://StateMachine/state.gd"

const FALL_SPEED: = 0.005

func update(delta):
	var scale = owner.get_scale()
	if scale.length() > 0.01:
		owner.set_scale(scale - Vector2(FALL_SPEED, FALL_SPEED))
	else:
		owner.die()

func enter(arguments: Dictionary):
	print('falling')

func exit():
	print('flying?')
