extends Area2D

var CUSTOM_INPUT_MAP = [KEY_A]
var COOLDOWN = 1
var DAMAGE = 1 setget ,get_damage
var SPEED = 400 setget ,get_speed
var EXPLOSION_RADIUS = 0.0
var done: = false

remotesync var network_position: Vector2

func _init():
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta: float):
	if get_tree().is_network_server():
		move(delta)
	else:
		set_position(Network.interpolate_position(position, network_position))

func move(_delta: float):
	pass

func fire(fire_position: Vector2, new_target: Vector2):
	$CollisionShape2D.set_disabled(false)
	do_fire(fire_position, new_target)

func do_fire(_fire_position: Vector2, _new_target: Vector2):
	pass

func get_damage():
	return DAMAGE

func get_speed():
	return SPEED

func _on_body_entered(body: Node):
	if get_tree().is_network_server() and body != self.get_parent():
		end_skill_lifetime(body)

func end_skill_lifetime(body: Node):
	if EXPLOSION_RADIUS > 0.0:
		rpc("explode")
		explode_area()
		done = true
	elif body:
		rpc("hit", body, true)

remotesync func explode():
	pass

func explode_area():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		var skill_origin = global_transform.get_origin()
		var player_origin = player.get_global_transform().get_origin()
		if skill_origin.distance_to(player_origin) < EXPLOSION_RADIUS:
			rpc("hit", player, false)

remotesync func hit(body: Node, delete: bool):
	if body and body.has_method("damage"):
		body.damage(DAMAGE, self.get_global_position())
	if delete:
		delete_skill()

func delete_skill():
	if get_tree().is_network_server():
		rpc("remote_delete_skill")

remotesync func remote_delete_skill():
	queue_free()
