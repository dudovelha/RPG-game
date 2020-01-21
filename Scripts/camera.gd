extends Camera2D

func _input(event):
	if Input.is_action_pressed("zoom_in"):
			_zoom(Vector2(-0.1, -0.1))
	if Input.is_action_pressed("zoom_out"):
			_zoom(Vector2(0.1, 0.1))

func _zoom(vec):
	var new_zoom = zoom + vec
	if new_zoom.x > 0 and new_zoom.length() < 2.5:
		zoom = new_zoom