extends Node

signal player_connected
signal player_disconnected

func _ready():
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("network_peer_connected", self, "_on_player_connected")

func _on_Create_pressed():
	Network.create_server($Form/Name.text, get_random_color())
	delete_buttons()

func _on_Join_pressed():
	Network.connect_to_server($Form/Name.text, get_random_color())
	delete_buttons()

func delete_buttons():
	$Form.queue_free()

func _on_player_connected(player_id):
	emit_signal("player_connected")
	return player_id

func _on_player_disconnected(player_id):
	emit_signal("player_disconnected")
	return player_id

func get_random_color() -> Color:
	var r = random_zero_one()
	var g = random_zero_one()
	var b = random_zero_one()
	return Color(r, g, b, 1.0)

func random_zero_one() -> float:
	randomize()
	return ((randi() % 256) / 255.0)
