extends "res://Skills/skill.gd"

var direction: Vector2
var target: Vector2

func _init():
	CUSTOM_INPUT_MAP = [KEY_A]
	COOLDOWN = 1
	DAMAGE = 10
	SPEED = 400
	EXPLOSION_RADIUS = 100.0

func move(delta: float):
	if direction:
		var new_position = get_position() + (direction * SPEED * delta)
		set_position(new_position)
		rset_unreliable("network_position", new_position)

func do_fire(fire_position: Vector2, new_target: Vector2):
	set_as_toplevel(true)
	set_position(fire_position)
	direction = (new_target - position).normalized()
	$Target.set_as_toplevel(true)
	$Target.set_global_position(new_target)
	$Target.set_collision_layer_bit(4, true)

remotesync func explode():
	direction = Vector2.ZERO
	$Explosion.play(EXPLOSION_RADIUS)
	$ParticlesFlame.set_visible(false)
	$Light2D.set_scale($Light2D.get_scale() * 2.5)
	$LighDimmer.start()

func _on_Target_area_entered(area: Area2D):
	if get_tree().is_network_server() and area == self:
		end_skill_lifetime(null)

func _on_LighDimmer_timeout():
	if $Light2D.get_energy() > 0.0:
		$Light2D.set_energy($Light2D.get_energy() - 0.05)
