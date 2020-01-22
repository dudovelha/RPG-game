extends Area2D

var FIREBALL_SPEED = 400

var direction: Vector2
var target: Vector2

func _ready():
	set_as_toplevel(true)
	$Target.set_as_toplevel(true)
	$Target.set_collision_mask(get_collision_mask())

func _process(delta):
	set_position(get_position() + (direction * FIREBALL_SPEED * delta))

func fire(new_target: Vector2):
	direction = (new_target - position).normalized()
	$Target.set_global_position(new_target)

func _on_Fireball_body_entered(body):
	if body != self.get_parent():
		print("Fireball hit ", body.name)
		self.queue_free()


func _on_Target_area_entered(area: Area2D):
	if area == self:
		print("Fireball hit target")
		self.queue_free()
