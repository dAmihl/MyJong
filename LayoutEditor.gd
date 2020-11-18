tool
extends Spatial

var cols = 20
var rows = 10

var nodes_distance_width:float = 2.2
var nodes_distance_height:float = 3.6
var nodes_distance_depth:float = 1.1

var placement_node_scn = preload("res://Scenes/LayoutEditor/PlacementNode.tscn")
var layer_scn = preload("res://Scenes/LayoutEditor/Layer.tscn")

onready var layers = []
var current_layer:int = 0

var current_layout:LayoutManager.Layout = null setget set_current_layout

var num_tiles = 0

signal num_tiles_changed

func _ready():
	spawn_placement_nodes(0)
	center_board_position()
	init_nodes()
	pass

func center_board_position():
	var pos_x = (float(rows) * nodes_distance_height) / 2.0
	var pos_z = (float(cols) * nodes_distance_width) / 2.0
	$PlacementGrid.translation.x = -pos_x
	$PlacementGrid.translation.z = -pos_z
	pass
	
func init_nodes():
	for n in $PlacementGrid.get_children():
		n.init()
		pass

func set_current_layout(l:LayoutManager.Layout):
	current_layout = l
	$CanvasLayer/EditorGUI.set_current_layout(l)

func _input(event):
	if event.is_action_pressed("export_layout"):
		$PlacementGrid.export_layout()
	
func spawn_placement_nodes(layer:int):
	for r in range(0,rows):
		spawn_placement_nodes_row(r, layer)
		if (r + 0.5 < rows):
			spawn_placement_nodes_row(r+0.5, layer)
	pass

func spawn_placement_nodes_row(cur_row,layer:int):
	for c in range (0, cols):
			place_node(cur_row, c, layer)
			if (c + 0.5 < cols):
				#spawn halfstep node
				place_node(cur_row, c+0.5, layer)
	pass

func place_node(r, c, layer:int):
	var new_hs_node = placement_node_scn.instance()
	new_hs_node.position = Vector2(r,c)
	new_hs_node.layer = layer
	new_hs_node.translation = Vector3(r*nodes_distance_height, layer*nodes_distance_depth, c*nodes_distance_width)
	new_hs_node.connect("tile_placed", self, "_on_numTiles_Added")
	new_hs_node.connect("tile_removed", self, "_on_numTiles_Removed")
	new_hs_node.connect("tile_placed", $PlacementGrid, "_on_Tile_Placed")
	new_hs_node.connect("tile_removed", $PlacementGrid, "_on_Tile_Removed")
	$PlacementGrid.add_child(new_hs_node)
	

func load_layout(layoutFilePath:String):
	var layout = LayoutManager.create_layout_from_fullpath(layoutFilePath)
	if is_instance_valid(layout):
		init_layout(layout.layout_data)
		set_current_layout(layout)
	else:
		print("Error: File is damaged - "+str(layoutFilePath))

func init_layout(data:Array):
	var lNum = 0
	for layer in data:
		for n in layer:
			var node = find_placement_node(Vector2(n[0], n[1]), lNum)
			node.place_node_with_layer(lNum)
			pass
		lNum += 1
	update_node_layers()

func find_placement_node(pos:Vector2, layer:int)->Spatial:
	for n in $PlacementGrid.get_children():
		if n.position == pos:
			return n
	return null
	
func update_node_layers():
	for n in $PlacementGrid.get_children():
		n.update_layer()

func _on_EditorGUI_load_file_selected(path):
	clear()
	load_layout(path)
	pass # Replace with function body.

func clear():
	if $PlacementGrid.get_child_count() > 0:
		for c in $PlacementGrid.get_children():
			c.clear()
	num_tiles = 0
	emit_signal("num_tiles_changed", num_tiles)

func _on_numTiles_Added():
	num_tiles += 1
	emit_signal("num_tiles_changed", num_tiles)
	pass

func _on_numTiles_Removed():
	num_tiles -= 1
	emit_signal("num_tiles_changed", num_tiles)
	pass


func _on_EditorGUI_home_btn():
	SceneManager.change_scene("Levels/LayoutList.tscn")
	pass # Replace with function body.


func _on_SaveDialog_save_layout(layout_name:String, layout_author:String, layout_desc:String):
	var layout_data:Array = $PlacementGrid.export_layout()
	var layout_full_path
	var layout_to_save:LayoutManager.Layout
	if is_instance_valid(current_layout):
		layout_full_path = current_layout.layout_full_path
		current_layout.set_layout_data(layout_data)
		layout_to_save = current_layout
	else:
		var layout_file_name = (layout_name+str(OS.get_unix_time())).sha256_text()
		layout_full_path = LayoutManager.customLayoutDirPath+layout_file_name
		var new_layout:LayoutManager.Layout = LayoutManager.Layout.new(
			layout_full_path, layout_data, layout_author, layout_name)
		layout_to_save = new_layout
		set_current_layout(layout_to_save)
	var file = File.new()
	file.open(layout_full_path, File.WRITE)
	file.store_string(layout_to_save.to_dict_json())
	file.close()
	pass # Replace with function body.


func _on_EditorGUI_clear_btn():
	clear()
	pass # Replace with function body.


func _on_EditorGUI_new_btn():
	clear()
	current_layout = null
	$CanvasLayer/EditorGUI.clear_current_layout()
	pass # Replace with function body.
