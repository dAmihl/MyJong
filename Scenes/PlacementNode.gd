extends StaticBody

var position:Vector2 = Vector2(0,0)
var layer:int = 0

var is_tile_set:bool = false
var disabled:bool = false

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
	if disabled:
		return
	$TileMesh.visible = !$TileMesh.visible
	is_tile_set = $TileMesh.visible
	for a in $Area.get_overlapping_bodies():
		if a == self:
			continue
		a.check_disabled()
	pass

func set_disabled(d:bool = true):
	disabled = d
	$Sphere.visible = !disabled
	self.set_process_input(!disabled)
	
func check_disabled():
	for a in $Area.get_overlapping_areas():
		if (a == self):
			continue
		var a_parent = a.get_parent()
		if a_parent.is_tile_set:
			var other_pos:Vector2 = a_parent.position
			var other_layer:int = a_parent.layer
			var dist = other_pos - self.position
			if abs(dist.x) < 1 and abs(dist.y) < 1:
				self.set_disabled(true)
				return
	self.set_disabled(false)
