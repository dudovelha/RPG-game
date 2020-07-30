extends Area2D

const CUSTOM_INPUT_MAP = [KEY_A]
const COOLDOWN = 1
const DAMAGE = 10

var FIREBALL_SPEED = 400

var direction: Vector2
var target: Vector2

func _process(delta):
	set_position(get_position() + (direction * FIREBALL_SPEED * delta))

func fire(fire_position: Vector2, new_target: Vector2):
	set_as_toplevel(true)
	set_position(fire_position)
	direction = (new_target - position).normalized()
	$Target.set_as_toplevel(true)
	$Target.set_global_position(new_target)
	$Target.set_collision_layer_bit(4, true)

func _on_Fireball_body_entered(body: Node):
	if body != self.get_parent():
		print("Fireball hit ", body.name)
		if body.has_method("damage"):
			body.damage(DAMAGE)
		self.queue_free()

func _on_Target_area_entered(area: Area2D):
	if area == self:
		print("Fireball hit target")
		self.queue_free()
