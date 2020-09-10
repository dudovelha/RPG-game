extends Sprite

var done: = false
const ASCEND_SPEED: = 0.01

func _process(delta):
	if visible:
		var scale = owner.get_scale()
		var color = owner.get_modulate()
		if color.a > 0.0:
			owner.set_scale(scale + Vector2(ASCEND_SPEED, ASCEND_SPEED))
			color.a = color.a - (ASCEND_SPEED/5.0)
			owner.set_modulate(color)
		else:
			owner.queue_free()

