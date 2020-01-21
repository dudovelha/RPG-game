extends Node

func _on_Create_pressed():
	Network.create_server($Form/Name.text, $Form/ColorPickerButton.get_pick_color())
	delete_buttons()

func _on_Join_pressed():
	Network.connect_to_server($Form/Name.text, $Form/ColorPickerButton.get_pick_color())
	delete_buttons()

func delete_buttons():
	$Form.queue_free()