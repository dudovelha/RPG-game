extends KinematicBody2D

var REMOTE_CONTROLLED: bool
var SPEED: = 100 setget , get_speed
var SPEED_MODIFIER: = 1.0

onready var HUD = $"/root/Main/HUD"

func init(name: String, color: Color, start_position: Vector2, is_remote: bool):
	global_position = start_position
	REMOTE_CONTROLLED = is_remote
	$Pivot/BodySprite.set_modulate(color)
	$Name.set_text(name)

func _ready():
	pass

func get_speed():
	return SPEED * SPEED_MODIFIER

func get_position():
	return get_node("Pivot").get_global_position()
