extends Control

func disable_HUD(player):
	hide()
	set_process(false)

func set_process_all(current, active):
	if current.has_method("set_process"):
		current.set_process(active)
	var children = get_children()
	for child in children:
		set_process_all(child, active)
