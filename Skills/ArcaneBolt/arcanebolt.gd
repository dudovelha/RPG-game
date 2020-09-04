extends "res://Skills/skill.gd"

const MAX_SPEED = 500
const MIN_DISTANCE = 500

var direction: Vector2
var firing_player: KinematicBody2D
var target: KinematicBody2D
var speed: float

func _init():
	CUSTOM_INPUT_MAP = [KEY_B]
	COOLDOWN = 1
	DAMAGE = 2
	SPEED = 100


func move(delta: float):
	var new_position
	if target:
		new_position = get_position() + (get_target_direction() * get_speed() * delta)
	elif direction:
		new_position = get_position() + (direction * get_speed() * delta)
		find_target()
	if new_position:
		set_position(new_position)
		rset_unreliable("network_position", new_position)

func do_fire(fire_position: Vector2, new_target: Vector2):
	$KillTimer.start()
	speed = 0
	firing_player = owner
	set_as_toplevel(true)
	set_position(fire_position)
	direction = (new_target - position).normalized()

func find_target():
	var players = get_tree().get_nodes_in_group("player")
	var smaller_distance = 999999
	var new_target
	for player in players:
		var distance = position.distance_to(player.get_position())
		if player != firing_player and distance < smaller_distance:
			smaller_distance = distance
			new_target = player
	if smaller_distance < MIN_DISTANCE:
		target = new_target

func get_target_direction():
	var target_position = target.get_position()
	var new_direction = global_transform.get_origin().direction_to(target_position)
	return new_direction

func get_speed():
	speed += 1
	return clamp(SPEED + speed, SPEED, MAX_SPEED)

func _on_KillTimer_timeout():
	queue_free()
