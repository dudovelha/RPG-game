extends "res://StateMachine/state.gd"

var custom_input_map = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]

var velocity: Vector2 = Vector2.ZERO

func enter(arguments):
	return arguments

func exit():
	return

func handle_input():
	if Input.is_action_just_pressed("Jump"):
		emit_signal("finished", "Jump", {"velocity": velocity})
	if Input.is_action_just_pressed("Dash"):
		emit_signal("finished", "Dash", {"velocity": velocity})

func update(delta):
	if is_network_master():
		var vec = Vector2.ZERO
		var new_position = owner.current_position
		if Input.is_key_pressed(KEY_LEFT):
			vec.x -= 1
		if Input.is_key_pressed(KEY_RIGHT):
			vec.x += 1
		if Input.is_key_pressed(KEY_UP):
			vec.y -= 1
		if Input.is_key_pressed(KEY_DOWN):
			vec.y += 1
		
		if not vec == Vector2.ZERO:
			velocity = vec * owner.get_speed() * delta
			new_position += velocity
			set_current_position(new_position)
		else:
			emit_signal("finished", "previous", {})

func set_current_position(new_position):
	if owner.is_network_master():
		owner.rset_unreliable("current_position", new_position)
		owner.current_position = new_position

func _on_animation_finished(anim_name):
	return
