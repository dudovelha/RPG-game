extends "res://StateMachine/state.gd"

func handle_input(event):
	if Input.is_action_pressed("Move"):
		emit_signal("finished", "Move", {})
	elif Input.is_action_pressed("Jump"):
		emit_signal("finished", "Jump", {})