extends MarginContainer

export (NodePath) var players_node
export var zoom = 1.5

onready var grid = $MarginContainer/Grid

var grid_scale
var markers = {}

func _ready():
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)

func _on_player_update():
	var players = get_node(players_node)

func _process(delta):
	pass
