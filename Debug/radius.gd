extends Line2D


func draw_custom_circle(center, radius):
	clear_points()
	for deg in range(0, 361):
		var angle = deg2rad(1.0 * deg)
		add_point(center + get_point(angle, radius))

func get_point(angle: float, radius: int):
	var s = sin(angle)
	var c = cos(angle)
	return Vector2(s * radius, c * radius)
