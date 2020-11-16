tool
extends Spatial

var cols = 15
var rows = 8

var nodes_distance_width:float = 2.2
var nodes_distance_height:float = 3.6
var nodes_distance_depth:float = 1.1

var placement_node_scn = preload("res://Scenes/LayoutEditor/PlacementNode.tscn")
var layer_scn = preload("res://Scenes/LayoutEditor/Layer.tscn")

onready var layers = []
var current_layer:int = 0

func _ready():
	spawn_placement_nodes(0)
	load_layout()
	pass
	
func _input(event):
	if event.is_action_pressed("export_layout"):
		$PlacementGrid.export_layout()
	if event.is_action_pressed("save"):
		save_layout()
	
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
	$PlacementGrid.add_child(new_hs_node)
	

func save_layout(layoutName:String = "testlayout"):
	var layoutstr:String = $PlacementGrid.export_layout()
	var layoutFilePath = "user://"+layoutName+".layout"
	var file = File.new()
	file.open(layoutFilePath, File.WRITE)
	file.store_string(layoutstr)
	file.close()

func load_layout(layoutName:String = "testlayout"):
	var layoutFilePath = "user://"+layoutName+".layout"
	var file = File.new()
	file.open(layoutFilePath, File.READ)
	var layoutstr = file.get_as_text()
	file.close()
	var result_json = JSON.parse(layoutstr)

	if result_json.error == OK:  # If parse OK
		var data = result_json.result
		init_layout(data)
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)

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
	
