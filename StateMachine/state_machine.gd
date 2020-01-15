extends Node

signal state_changed(states_stack)

var states_map = {}
var states_stack = []
var current_state: Node = null

func _ready():
	states_stack.push_front(get_child(0))
	current_state = states_stack[0]
		
	for state in get_children():
		state.connect("finished", self, "_change_state")
		states_map[state.name] = state


func _process(delta):
	if current_state.is_active():
		current_state.update(delta)

func _input(event):
	current_state.handle_input(event)
	
func _change_state(state_name: String, arguments: Dictionary):
	var is_state = is_state(state_name)
	current_state.exit()
	if not is_state:
		states_stack.pop_front()
	else: 
		states_stack.push_front(states_map[state_name])
	
	current_state = states_stack[0]
	if is_state:
		current_state.enter(arguments)
	emit_signal("state_changed", states_stack)

func is_state(state_name: String):
	return states_map.keys().has(state_name)