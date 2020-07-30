extends KinematicBody2D

var REMOTE_CONTROLLED: bool
var SPEED: = 100 setget , get_speed
var SPEED_MODIFIER: = 1.0
puppet var current_position = Vector2.ZERO
var life = 100
var mana = 100

signal update_resources(life, mana)

func init(name: String, color: Color, start_position: Vector2, is_remote: bool):
	global_position = start_position
	REMOTE_CONTROLLED = is_remote
	$Pivot/BodySprite.set_self_modulate(color)
	$HUD/Name.set_text(name)

func _physics_process(delta):
	update_position(delta)

func update_position(delta: int):
	if is_network_master():
		position = current_position
	else:
		interpolate_position(delta)

func interpolate_position(delta: int):
	var scale_factor = 0.1
	var dist = position.distance_to(current_position)
	var weight = clamp(pow(2,dist/4)*scale_factor,0.0,1.0)
	position = position.linear_interpolate(current_position,weight)

func _ready():
	emit_signal("update_resources", life, mana)

func damage(damage):
	life -= damage
	emit_signal("update_resources", life, mana)

func get_speed():
	return SPEED * SPEED_MODIFIER

func get_position():
	return get_node("Pivot").get_global_position()
