extends StaticBody

var position:Vector2 = Vector2(0,0)
var layer:int = 0

signal layout_tile_removed

func _on_LayoutTile_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		get_parent().call_deferred("remove_child", self)
	pass # Replace with function body.
