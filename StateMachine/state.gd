extends Node

signal finished(next_state_name)

var _active = true setget set_active, is_active

func _ready():
	configure_input()
	print(owner.name +' state ready: '+self.name)

func enter(arguments: Dictionary):
	return arguments

func exit():
	return

func handle_input(event):
	return event

func update(delta):
	return delta

func _on_animation_finished(anim_name):
	return anim_name

func set_active(active):
	_active = active

func is_active():
	return _active

func configure_input():
	if !owner.REMOTE_CONTROLLED and self.get('custom_input_map'):
		var action_name = self.name
		InputMap.add_action(action_name)
		for key in self.custom_input_map:
			var new_input = InputEventKey.new()
			new_input.set_scancode(key)
			InputMap.action_add_event(action_name, new_input)