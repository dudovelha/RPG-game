extends Line2D

var deg: = 0
var radius: = 0

signal done_cutting

func _ready():
	$Timer.set_wait_time(owner.SHRINK_TIME/360.0)

func start_cutting(new_radius):
	clear_points()
	deg = 0
	radius = new_radius
	$Timer.start()
	$Fire.set_emitting(true)

func get_point(angle: float, radius: int):
	var s = sin(angle)
	var c = cos(angle)
	return Vector2(s * radius, c * radius)


func _on_Timer_timeout():
	if deg <= 360:
		var angle = deg2rad(1.0 * deg)
		var point = get_point(angle, radius)
		add_point(point)
		$Fire.set_position(point)
		deg += 1.0
		$Timer.start()
	else:
		$Fire.set_emitting(false)
		emit_signal("done_cutting")
