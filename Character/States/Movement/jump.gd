extends "res://StateMachine/state.gd"

var custom_input_map = [KEY_SPACE]

const MAX_HEIGHT: = 200.0
const GRAVITY: = 600.0

var enter_velocity: = Vector2.ZERO
var vertical_velocity: = 0.0
var height: = 0.0

func enter(arguments):
	enter_velocity = arguments.get("velocity", Vector2.ZERO)
	vertical_velocity = 300.0
	height = 0.0
	owner.set_collision_layer(2)

func exit():
	owner.set_collision_layer(1)

func update(delta):
	var jump_height = get_jump_height(delta)
	
	rpc("jump", jump_height, enter_velocity)
	
	if height <= 0.0:
		emit_signal("finished", "previous", {})

func get_jump_height(delta):
	vertical_velocity -= GRAVITY * delta
	height += vertical_velocity * delta
	height = clamp(height, 0.0, MAX_HEIGHT)
	
	return -height

remotesync func jump(height, enter_velocity):
	owner.get_node("Pivot").position.y = height
	owner.position += enter_velocity