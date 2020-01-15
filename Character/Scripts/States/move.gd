extends "res://StateMachine/state.gd"

var custom_input_map = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]

const SPEED = 100

var velocity: Vector2 = Vector2.ZERO

func enter(arguments):
	return arguments

func exit():
	return

func handle_input(event):
	if Input.is_action_pressed("Jump"):
		emit_signal("finished", "Jump", {"velocity": velocity})

func update(delta):
	var vec = Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT):
		vec.x -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		vec.x += 1
	if Input.is_key_pressed(KEY_UP):
		vec.y -= 1
	if Input.is_key_pressed(KEY_DOWN):
		vec.y += 1
	
	if not vec == Vector2.ZERO:
		velocity = vec * SPEED
		owner.move_and_slide(velocity)
	else:
		emit_signal("finished", "previous", {})

func _on_animation_finished(anim_name):
	return