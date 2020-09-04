extends "res://StateMachine/state.gd"

const POSITION_OFFSET = Vector2(0, -15)

export(PackedScene) var Skill
var custom_input_map: Array
var skill_name: String
var skill: Node

func _enter_tree():
	var variables_skill = Skill.instance()
	custom_input_map = variables_skill.CUSTOM_INPUT_MAP
	skill_name = variables_skill.name
	create_cooldown(variables_skill.COOLDOWN)
	variables_skill.queue_free()

func create_cooldown(wait_time):
	var timer = Timer.new()
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.name = "Cooldown"
	add_child(timer)

func enter(_arguments):
	if owner.is_network_master():
		rpc("spawn_skill")

func handle_input():
	if Input.is_action_just_pressed("click"):
		fire_event()
	if Input.is_action_just_pressed("ui_cancel"):
		if owner.is_network_master():
			rpc("delete_skill")
		emit_signal("finished", "previous", {})

func fire_event():
	if is_network_master():
		if $Cooldown.is_stopped():
			$Cooldown.start()
			rpc("fire", owner.get_global_mouse_position())
			emit_signal("finished", "previous", {})

remotesync func spawn_skill():
	var new_skill = Skill.instance()
	owner.add_child(new_skill)
	new_skill.set_owner(self.owner)
	new_skill.set_position(POSITION_OFFSET)
	skill = new_skill

remotesync func delete_skill():
	if skill:
		skill.queue_free()
		skill = null

remotesync func fire(target):
	if skill:
		skill.fire((owner.position + POSITION_OFFSET), target)
