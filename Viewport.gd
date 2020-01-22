extends Viewport

onready var viewport1 = get_node("../../ViewportContainer/Viewport")

func _ready():
	world_2d = viewport1.get_viewport().world_2d
