extends Node

func init_player(new_player_id, data):
	var new_player = load("res://Character/Character.tscn").instance()
	new_player.name = str(new_player_id)
	new_player.set_network_master(new_player_id)
	new_player.init(data.name, data.color, data.position)
	return new_player

func update_UI(player):
	if player.is_network_master():
		update_HUD_nodes(player)
	else:
		add_resources_node(player)

func add_resources_node(new_player: KinematicBody2D):
		var resources = load("res://HUD/Resources/Resources.tscn").instance()
		new_player.get_node("HUD").add_child(resources)
		resources.set_alignment(HALIGN_CENTER)
		resources.set_position(Vector2(0, 20))
		new_player.connect("update_resources", resources, "update_resources")
		new_player.emit_signal("update_resources", new_player.life, new_player.mana)
		resources.set_size(Vector2(50, 5))

func update_HUD_nodes(new_player: KinematicBody2D):
	var camera = $"/root/Main/Camera"
	var HUD = $"/root/Main/HUD/Control"
	var minimap = HUD.get_node("Minimap")
	var resources = HUD.get_node("Resources")
	$"/root/Main".remove_child(camera)
	new_player.add_child(camera)
	new_player.connect("hit", camera, "add_trauma")
	HUD.show()
	minimap.set_main_object(new_player)
	new_player.connect("update_resources", resources, "update_resources")
	new_player.emit_signal("update_resources", new_player.life, new_player.mana)
