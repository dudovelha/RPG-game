extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 5

var players = { }
var self_data = { name = '', color = Color.black, position = Vector2(360, 180) }

func _ready():
	var error = get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	if error:
		print("network_peer_disconnected", error)
	error = get_tree().connect("network_peer_connected", self, "_on_player_connected")
	if error:
		print("network_peer_disconnected", error)

func create_server(player_nickname: String, color: Color):
	self_data.name = player_nickname
	self_data.color = color
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	_new_player_info(1, self_data, false)

func connect_to_server(player_nickname: String, color: Color):
	self_data.name = player_nickname
	self_data.color = color
	var error = get_tree().connect("connected_to_server", self, "_connected_to_server")
	if error:
		print("network_peer_disconnected", error)
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _on_player_disconnected(id):
	get_node("/root/Main/World/Players/"+str(id)).queue_free()
	players.erase(id)

func _on_player_connected(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	if not get_tree().is_network_server():
		rpc("_request_player_info", local_player_id, connected_player_id)

remote func _request_player_info(from_id, requested_id):
	print("player " + str(from_id) + " requested info for player " + str(requested_id))
	players[requested_id].position = get_node("/root/Main/World/Players/"+str(requested_id)).position
	rpc_id(from_id, "_new_player_info", requested_id, players[requested_id], true)

func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = self_data
	_new_player_info(local_player_id, self_data, false)
	rpc("_new_player_info", local_player_id, self_data, true)

remote func _new_player_info(new_player_id, data, is_remote):
	print("new player: "+ str(new_player_id))
	players[new_player_id] = data
	var new_player = Character_builder.init_player(new_player_id, data, is_remote)
	$"/root/Main/World/Players".add_child(new_player)
