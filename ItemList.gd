extends ItemList

func _ready():
	pass

func _on_States_state_changed(states_stack):
	clear()
	for state in states_stack:
		add_item(state.name)
