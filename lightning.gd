extends Line2D

var rng = RandomNumberGenerator.new()
export var MAX_RANGE = 1
export var GRANULARITY = 5
var distance = 200
var kill = true

func _ready():
	clear_points()
	var increment = distance / GRANULARITY
	var x = 0
	add_point(Vector2(0,0))
	for _i in range(GRANULARITY-2):
		x += increment
		add_point(Vector2(x, clamp(random(), -MAX_RANGE, MAX_RANGE)))
	add_point(Vector2(distance, 0))
	if kill:
		$KillTimer.start()

func _process(_delta):
	for i in range(GRANULARITY-2):
		var point = get_point_position(i+1)
		point.y = clamp(point.y + normalized_random(), -MAX_RANGE, MAX_RANGE)
		set_point_position(i+1, point)

func random():
	rng.randomize()
	return rng.randf_range(-MAX_RANGE, MAX_RANGE)

func normalized_random():
	rng.randomize()
	return rng.randf_range(-1, 1)

func _on_KillTimer_timeout():
	queue_free()
