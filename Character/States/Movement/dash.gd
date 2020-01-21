extends "res://StateMachine/state.gd"

var custom_input_map = [KEY_D]

var SPEED_MODIFIER: = 4.0

func ready():
	$Cooldown.connect("timeout", self, "_on_timer_timeout")

func enter(arguments):
	if $Cooldown.is_stopped():
		$Cooldown.start()
		owner.SPEED_MODIFIER += SPEED_MODIFIER
		owner.find_node("BodySprite").scale.y = 0.7
		owner.find_node("BodySprite").position.y += 5
	emit_signal("finished", "previous", {})

func _on_Timer_timeout():
	owner.SPEED_MODIFIER -= SPEED_MODIFIER
	owner.find_node("BodySprite").scale.y = 1.0
	owner.find_node("BodySprite").position.y -= 5
