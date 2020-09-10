extends Camera2D

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.5  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.

onready var noise = OpenSimplexNoise.new()
var trauma: = 0.0  # Current shake strength.
var trauma_power: = 2  # Trauma exponent. Use [2, 3].
var noise_y: = 0
var spectate: = false

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _input(event):
	if spectate and Input.is_action_just_pressed("ui_select"):
		change_parent()

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func current_player_died(player):
	spectate = true
	self_reparent($"/root/Main/World")

func add_trauma(amount, trauma_origin):
	trauma = min(trauma + (amount/100.0), 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func change_parent():
	var players = get_tree().get_nodes_in_group("player")
	var player_index = players.find(get_parent())
	if player_index != -1:
		var player = get_next_player(players, player_index)
		self_reparent(player)
	else:
		self_reparent($"/root/Main/World")

func self_reparent(new_parent):
	var old_parent = get_parent()
	old_parent.remove_child(self)
	new_parent.add_child(self)

func get_next_player(array: Array, index: int):
	if array.size() > index:
		return array[0]
	else:
		return array[index+1]
