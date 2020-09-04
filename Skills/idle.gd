extends "res://StateMachine/state.gd"

func handle_input():
	if Input.is_action_pressed("Fireball"):
		emit_signal("finished", "Fireball", {})
	if Input.is_action_pressed("ArcaneBolt"):
		emit_signal("finished", "ArcaneBolt", {})
	if Input.is_action_pressed("ChainLightning"):
		emit_signal("finished", "ChainLightning", {})
