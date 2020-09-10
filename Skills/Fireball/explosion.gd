extends CanvasLayer

var animation_finished: = false
var particles_finished: = false

func _ready():
	set_process(false)
	reset_force()

func play(radius: float):
	set_custom_shader_parameters(1.0)
	var size: float = radius * 2 / get_viewport().size.x
	var anim_track = $AnimationPlayer.get_animation("shockwave").track_set_key_value(0, 1, size)
	$AnimationPlayer.play("shockwave")
	$Particles2D.position = get_parent().get_global_transform_with_canvas().get_origin()
	$Particles2D.set_emitting(true)
	set_process(true)

func set_custom_shader_parameters(force: float):
	var material = $Shader.get_material()
	var position_on_canvas = get_parent().get_global_transform_with_canvas().get_origin()
	var viewport_size = get_viewport().get_size()
	var aspect_ratio = get_viewport().size.aspect()
	var pos_x = ((position_on_canvas.x/viewport_size.x) - 0.5) * aspect_ratio +0.5
	var pos_y = 1.0 - (position_on_canvas.y/viewport_size.y)
	material.set_shader_param("force", force)
	material.set_shader_param("center", Vector2(pos_x, pos_y))

func reset_force():
	$Shader.get_material().set_shader_param("force", 0.0)

func _on_AnimationPlayer_animation_finished(anim_name):
	reset_force()
	animation_finished = true

func _process(delta):
	if animation_finished and particles_finished and get_parent().done:
		get_parent().delete_skill()
	if not $Particles2D.is_emitting():
		particles_finished = true
