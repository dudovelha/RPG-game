extends MarginContainer

export var zoom = 1.5

onready var grid: Node = $MarginContainer/Grid
onready var main_object_icon:Node = $MarginContainer/Grid/MainObject

var main_object: Node
var grid_scale: Vector2
var markers = {}

func _ready():
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)

func set_main_object(object: Node2D):
	main_object_icon.position = grid.rect_size / 2
	main_object_icon.set_modulate(object.get_modulate())
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	main_object = object
	main_object_icon.show()
	

func _update_minimap():
	clear_minimap()
	yield(get_tree().create_timer(1.0), "timeout")
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = main_object_icon.duplicate()
		grid.add_child(new_marker)
		new_marker.set_modulate(item.get_modulate())
		new_marker.show()
		new_marker.name = item.name
		markers[item] = new_marker

func _process(_delta):
	if is_visible() and is_instance_valid(main_object):
		for item in markers:
			if is_instance_valid(item):
				var obj_pos = (item.get_global_position() - main_object.position) * grid_scale + grid.rect_size / 2
				if grid.get_rect().has_point(obj_pos + grid.rect_position):
					markers[item].scale = Vector2(0.2, 0.2)
				else:
					markers[item].scale = Vector2(0.1, 0.1)
				obj_pos.x = clamp(obj_pos.x, 5, grid.rect_size.x - 5)
				obj_pos.y = clamp(obj_pos.y, 5, grid.rect_size.y - 5)
				markers[item].position = obj_pos


func clear_minimap():
	for item in markers:
		markers[item].queue_free()
	markers.clear()
