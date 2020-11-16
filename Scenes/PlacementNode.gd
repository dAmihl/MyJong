extends StaticBody

var position:Vector2 = Vector2(0,0)
var layer:int = 0

var is_tile_set:bool = false
var disabled:bool = false

signal tile_placed
signal tile_removed

var nodes_distance_width:float = 2.2
var nodes_distance_height:float = 3.6
var nodes_distance_depth:float = 1.1
var layout_tile_scn = preload("res://Scenes/LayoutEditor/LayoutTile.tscn")

func _process(delta):
	check_available()
	
	pass

func _on_PlacementNode_mouse_entered():
	if disabled:
		return
	$Sphere.material.albedo_color = Color.yellow
	$TileMesh.visible = true
	pass # Replace with function body.

func _on_PlacementNode_mouse_exited():
	if disabled:
		return
	$Sphere.material.albedo_color = Color(0,0,0,0.3)
	$TileMesh.visible = false
	pass # Replace with function body.


func _on_PlacementNode_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			on_clicked()
		if event.button_index == BUTTON_RIGHT:
			remove_node()
	pass # Replace with function body.

func on_clicked():
	if disabled:
		return
	#emit_signal("on_node_placed",self)
	place_node()
	elevate_layer()
	pass

func check_available():
	var colliders = $Area.get_overlapping_bodies()
	var colliders_same_layer = []
	for c in colliders:
		if c.layer == layer:
			colliders_same_layer.append(c)
	
	if colliders_same_layer.size() >= 2:
		elevate_layer()
		return
	
	for c in colliders_same_layer:
		var dPosition = c.position - position
		if abs(dPosition.x) < 1 and abs(dPosition.y) < 1:
			toggle_enabled(false)
			return
	
	if colliders.size() - colliders_same_layer.size() > 0:
		toggle_enabled(false)
	else:
		toggle_enabled(true)

func toggle_enabled(enabled:bool = true):
	$Sphere.visible = enabled
	set_process_input(enabled)
	disabled = !enabled

func elevate_layer():
	set_layer(layer + 1)
	
func decrease_layer():
	set_layer(max(layer-1,0))

func remove_node():
	if $Tiles.get_child_count() > 0:
		$Tiles.remove_child($Tiles.get_child($Tiles.get_child_count()-1))
		decrease_layer()
		emit_signal("tile_removed")

func place_node():
	var new_tile = layout_tile_scn.instance()
	#new_tile.translation = self.translation
	new_tile.position = self.position 
	new_tile.layer = layer
	$Tiles.add_child(new_tile)
	emit_signal("tile_placed")
	pass
	
func place_node_with_layer(layerNum:int = 0):
	var new_tile = layout_tile_scn.instance()
	#new_tile.translation = self.translation
	new_tile.position = self.position 
	new_tile.layer = layerNum
	$Tiles.add_child(new_tile)
	emit_signal("tile_placed")
	pass
	
func update_layer():
	# Only update those with children. Otherwise keep at 0
	if $Tiles.get_child_count() == 0:
		return
	var max_layer = 0
	for c in $Tiles.get_children():
		if c.layer > max_layer:
			max_layer = c.layer
	set_layer(max_layer+1)
	
func set_layer(layerNum:int):
	layer = layerNum
	translation.y = layer * nodes_distance_depth 
	for t in $Tiles.get_children():
		t.translation.y = (t.layer - layer) * nodes_distance_depth
	pass
	
func get_tiles():
	return $Tiles.get_children()
