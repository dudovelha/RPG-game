extends "res://StateMachine/state.gd"

var custom_input_map = [KEY_SPACE]

const MAX_HEIGHT = 200.0

var enter_velocity = Vector2.ZERO
var starting_point = Vector2.ZERO
var landing_point = Vector2.ZERO
var highest_point = Vector2.ZERO
var time = 0.0
var height = 0.0

func _ready():
	$start.custom_color = Color.white
	$land.custom_color = Color.black
	$high.custom_color = Color.red

func enter(arguments):
	enter_velocity = arguments.get("velocity", Vector2.ZERO)
	set_jumping_points()
	debug()
	time = 0

func set_jumping_points():
	starting_point = owner.position
	landing_point = starting_point + enter_velocity
	var vec = starting_point + (landing_point - starting_point) / sqrt(2)
	var deg = 0
	
	if vec.x == 0:
		vec = Vector2(starting_point.x, starting_point.y-MAX_HEIGHT)
	elif vec.x < 0:
		deg = 45
	else:
		deg = -45
	
	vec = vec.rotated(deg2rad(deg))
	highest_point = vec

func update(delta):
	move_horizontally(delta)
	
	#owner.move_and_slide(enter_velocity)
	
	if time >= 1.0:
		emit_signal("finished", "previous", {})

func move_horizontally(delta):
	time += 1 * delta
	var new_position = _quadratic_bezier(starting_point, highest_point, landing_point, time)
	
	owner.set_position(new_position)

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var r = q0.linear_interpolate(q1, t)
	return r

func debug():
	$start.set_global_position(starting_point)
	$land.set_global_position(landing_point)
	$high.set_global_position(highest_point)