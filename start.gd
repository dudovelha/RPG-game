extends Node2D

var custom_color = Color.red

func _ready():
	pass

func _draw():
	draw_circle(get_global_position(), 5, custom_color)