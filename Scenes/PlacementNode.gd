extends StaticBody

var position:Vector2 = Vector2(0,0)
var layer:int = 0

var is_tile_set:bool = false

func _on_PlacementNode_mouse_entered():
	$Sphere.material.albedo_color = Color.yellow
	pass # Replace with function body.


func _on_PlacementNode_mouse_exited():
	$Sphere.material.albedo_color = Color.white
	pass # Replace with function body.


func _on_PlacementNode_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		on_clicked()
	pass # Replace with function body.

func on_clicked():
	$TileMesh.visible = !$TileMesh.visible
	is_tile_set = $TileMesh.visible
	pass
	
