extends KinematicBody2D

const MAX_LIFE = 100.0

var SPEED: = 100 setget , get_speed
var SPEED_MODIFIER: = 1.0
var ON_FLOOR: = true
var player_name: String
remotesync var network_position = Vector2.ZERO
remotesync var life = MAX_LIFE
remotesync var mana = 100

signal update_resources(life, mana)
signal hit(damage, damage_origin)
signal death(player)

func init(name: String, color: Color, start_position: Vector2):
	global_position = start_position
	$Pivot/BodySprite.set_self_modulate(color)
	$HUD/Name.set_text(name)
	player_name = name

func _physics_process(delta: float):
	update_position(delta)

func update_position(_delta: float):
	if is_network_master():
		position = network_position
	else:
		position = Network.interpolate_position(position, network_position)

func _ready():
	emit_signal("update_resources", life, mana)

func damage(damage, damage_origin):
	if get_tree().is_network_server():
		rpc("remote_update_life", damage, damage_origin)

remotesync func remote_update_life(damage, damage_origin):
	life = life-damage
	emit_signal("update_resources", life, mana)
	emit_signal("hit", damage, damage_origin)
	if life <= 0 and get_tree().is_network_server():
		die()

func get_speed():
	return SPEED * SPEED_MODIFIER

func get_position():
	return get_node("Pivot").get_global_position()

func die():
	if get_tree().is_network_server():
		rpc("remote_die", self.position)

remotesync func remote_die(death_position):
	position = death_position
	$HUD.hide()
	$Death.show()
	emit_signal("death", self)

