extends "res://StateMachine/state.gd"

func handle_input():
	if Input.is_action_pressed("Fireball"):
		emit_signal("finished", "Fireball", {})
