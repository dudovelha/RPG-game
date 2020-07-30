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
	if owner.is_network_master():
		rpc("set_in_air", true)

func exit():
	if owner.is_network_master():
		rpc("set_in_air", false)

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

func set_current_position(new_position):
	if owner.is_network_master():
		owner.current_position = new_position
		owner.rset_unreliable("current_position", new_position)

remotesync func set_in_air(is_in_air):
	owner.set_collision_mask_bit(0, !is_in_air)
	owner.set_collision_mask_bit(1, is_in_air)

remotesync func jump(height, enter_velocity):
	owner.get_node("Pivot").position.y = height
	set_current_position(owner.position + enter_velocity)
