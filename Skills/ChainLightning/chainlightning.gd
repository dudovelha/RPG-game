extends "res://Skills/skill.gd"

const HEIGHT = 30.0
const WIDTH = 60.0

onready var Lightning = preload("res://Skills/ChainLightning/Lightning.tscn")
var rng = RandomNumberGenerator.new()
var direction: Vector2
var target: Vector2

func _init():
	CUSTOM_INPUT_MAP = [KEY_C]
	COOLDOWN = 1
	DAMAGE = 2

func do_fire(_fire_position: Vector2, _new_target: Vector2):
	set_as_toplevel(true)
	$LightningContainer.queue_free()
	$SpawnTimer.stop()

func _ready():
	spawn_curved_lightning(Vector2.ZERO, Vector2(-WIDTH/2, HEIGHT/2), Vector2(0, HEIGHT), 5.0, false)
	spawn_curved_lightning(Vector2.ZERO, Vector2(WIDTH/2, HEIGHT/2), Vector2(0, HEIGHT), 5.0, false)
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	spawn_curved_lightning(Vector2(0, HEIGHT), random_pos(), random_pos(), 2.0, true)
	spawn_curved_lightning(Vector2(0, HEIGHT), random_pos(), random_pos(), 3.0, true)

func spawn_curved_lightning(start: Vector2, middle: Vector2, end: Vector2, quantity: float, kill: bool):
	var last_point = _quadratic_bezier(start, middle, end, 0)
	for t in range(int(quantity)):
		var current_point = _quadratic_bezier(start, middle, end, (t+1.0)/quantity)
		spawn_lightning(last_point, current_point, kill)
		last_point = current_point

func spawn_lightning(start: Vector2, end: Vector2, kill: bool):
	var new_lightning = Lightning.instance()
	new_lightning.kill = kill
	new_lightning.position = start
	new_lightning.distance = start.distance_to(end)
	$LightningContainer.add_child(new_lightning)
	new_lightning.look_at(global_transform.origin + end)

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	return q0.linear_interpolate(q1, t)

func random_pos():
	rng.randomize()
	var x = rng.randf_range(-WIDTH/1.5, WIDTH/1.5)
	rng.randomize()
	var y = rng.randf_range(HEIGHT, HEIGHT*1.5)
	return Vector2(x, y)
