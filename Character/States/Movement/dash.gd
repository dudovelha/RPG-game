extends "res://StateMachine/state.gd"

var custom_input_map = [KEY_D]

var SPEED_MODIFIER: = 4.0

func ready():
	$Cooldown.connect("timeout", self, "_on_timer_timeout")

func enter(_arguments):
	if $Cooldown.is_stopped():
		$Cooldown.start()
		if owner.is_network_master():
			rpc("do_dash")
	emit_signal("finished", "previous", {})

func _on_Timer_timeout():
	if owner.is_network_master():
		rpc("stop_dash")

remotesync func do_dash():
	owner.SPEED_MODIFIER += SPEED_MODIFIER
	owner.find_node("BodySprite").scale.y = 0.7
	owner.find_node("BodySprite").position.y += 5

remotesync func stop_dash():
	owner.SPEED_MODIFIER -= SPEED_MODIFIER
	owner.find_node("BodySprite").scale.y = 1.0
	owner.find_node("BodySprite").position.y -= 5
