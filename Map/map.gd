extends Node2D

export(PackedScene) var Gravestone
export(int) var SHRINK_SIZE = 10
export(int) var SHRINK_TIME = 10
export(float) var SHRINK_TIME_PAUSE = 1.0

func _ready():
	var radius = $Area2D/CollisionShape2D.shape.radius
	$CuttingRadius.start_cutting(radius - SHRINK_SIZE)
	
func player_died(player):
	var gravestone = Gravestone.instance()
	add_child(gravestone)
	gravestone.get_node("Label").set_text(player.player_name)
	gravestone.global_position = player.global_position

func _draw():
	var radius = $Area2D/CollisionShape2D.shape.radius
	draw_circle($Area2D.position, radius, Color( 0.5, 1, 1, 0.5))

func _on_CuttingRadius_done_cutting():
	var shape = $Area2D/CollisionShape2D.get_shape()
	var radius = shape.get_radius()
	
	radius -= SHRINK_SIZE
	shape.set_radius(radius)
	update()
	yield(get_tree().create_timer(SHRINK_TIME_PAUSE), "timeout")
	$CuttingRadius.start_cutting(radius - SHRINK_SIZE)

func _on_Area2D_body_exited(body):
	body.ON_FLOOR = false

func _on_Area2D_body_entered(body):
	body.ON_FLOOR = true
