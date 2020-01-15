extends Node2D

var starting_point = Vector2.ZERO
var landing_point = Vector2.ZERO
var highest_point = Vector2.ZERO

func _ready():
	pass

func _draw():
	draw_circle(starting_point, 4, Color.black)
	draw_circle(landing_point, 4, Color.green)
	draw_circle(highest_point, 4, Color.red)