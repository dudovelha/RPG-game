extends ParallaxBackground

const SPEED: = 100

func _process(delta):
	set_motion($Base, 1.0, delta)
	set_motion($Clouds3, 1.0, delta)
	set_motion($Clouds2, 1.5, delta)
	set_motion($Clouds1, 2.0, delta)
	set_motion_birb($Birb, 3.0, delta)

func set_motion(node: ParallaxLayer, factor: float, delta: float):
	node.motion_offset.y += (delta*SPEED) * factor
	node.motion_offset.x += (delta*SPEED/5) * factor

func set_motion_birb(node: ParallaxLayer, factor: float, delta: float):
	node.motion_offset.y -= (delta*SPEED) * factor
	node.motion_offset.x += (delta*SPEED/5) * factor
