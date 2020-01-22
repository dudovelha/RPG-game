extends "res://StateMachine/state.gd"

var custom_input_map = [KEY_A]

onready var Fireball = preload("Fireball.tscn")

func enter(arguments):
	if is_network_master():
		if $Cooldown.is_stopped():
			$Cooldown.start()
			rpc("fire", owner.get_position(), owner.get_global_mouse_position())
		emit_signal("finished", "previous", {})

remotesync func fire(position, target):
	var new_fireball = Fireball.instance()
	owner.add_child(new_fireball)
	new_fireball.set_position(position)
	new_fireball.fire(target)