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

var neighbours:Array = []

func _ready():
	pass
	
func init():
	neighbours = get_parent().get_neighbours_of_node(self)
	pass

func _on_PlacementNode_mouse_entered():
	if disabled:
		return
	print(layer)
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
	place_node()
	elevate_layer()
	pass

func update_neighbours():
	for n in neighbours:
		n.check_layer()

func check_layer():
	
	var num_neighbours_max_tiles:int = 0
	var num_neighbours_max_layer:int = 0
	var max_num_tiles = 0
	var max_layer = get_highest_tile_layer() 
	for n in neighbours:
		if n.has_tiles():
			var n_layer = n.get_highest_tile_layer() + 1
			if n_layer > max_layer:
				max_layer = n_layer
				num_neighbours_max_layer = 1
			if n_layer == max_layer:
				num_neighbours_max_layer += 1
	
	# rise
	if max_layer > get_highest_tile_layer():
		if num_neighbours_max_layer > 1:
			set_layer(max_layer)
			toggle_enabled(true)
		elif num_neighbours_max_layer == 1:
			toggle_enabled(false)
	# fall
	else:
		# stay above your highest tile
		set_layer(max(max_layer, get_highest_tile_layer()+1))
		toggle_enabled(true)

func num_tiles():
	return $Tiles.get_child_count()
	
func has_tiles():
	return num_tiles() > 0

func has_tile_on_layer() -> bool:
	if !has_tiles():
		return false
	for t in $Tiles.get_children():
		if t.layer == layer-1:
			return true
	return false
	
func get_highest_tile_layer() -> int:
	if !has_tiles():
		return -1
	else:
		var max_tile_layer = 0
		for t in $Tiles.get_children():
			if t.layer > max_tile_layer:
				max_tile_layer = t.layer
		return max_tile_layer

func toggle_enabled(enabled:bool = true):
	$Sphere.visible = enabled
	set_process_input(enabled)
	disabled = !enabled

func elevate_layer():
	set_layer(layer + 1)
	update_neighbours()
	
func decrease_layer():
	set_layer(max(layer-1,0))
	update_neighbours()

func remove_node():
	if $Tiles.get_child_count() > 0:
		var c = $Tiles.get_child($Tiles.get_child_count()-1)
		if c.layer == layer - 1:
			$Tiles.remove_child(c)
			decrease_layer()
			emit_signal("tile_removed", self)

func place_node():
	var new_tile = layout_tile_scn.instance()
	#new_tile.translation = self.translation
	new_tile.position = self.position 
	new_tile.layer = layer
	$Tiles.add_child(new_tile)
	emit_signal("tile_placed", self)
	pass
	
func place_node_with_layer(layerNum:int = 0):
	var new_tile = layout_tile_scn.instance()
	#new_tile.translation = self.translation
	new_tile.position = self.position 
	new_tile.layer = layerNum
	$Tiles.add_child(new_tile)
	elevate_layer()
	emit_signal("tile_placed", self)
	pass
	
func set_layer(layerNum:int):
	layer = layerNum
	translation.y = layer * nodes_distance_depth 
	for t in $Tiles.get_children():
		t.translation.y = (t.layer - layer) * nodes_distance_depth
	pass
	
func get_tiles():
	return $Tiles.get_children()
	
func clear():
	for t in $Tiles.get_children():
		t.queue_free()
	set_layer(0)
