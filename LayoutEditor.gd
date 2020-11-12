tool
extends Spatial

var cols = 15
var rows = 8

var nodes_distance_width:float = 2.2
var nodes_distance_height:float = 3.6
var nodes_distance_depth:float = 1.1

var placement_node_scn = preload("res://Scenes/LayoutEditor/PlacementNode.tscn")

var bGenerated:bool = false

func _ready():
	spawn_placement_nodes(0)
	pass

func spawn_placement_nodes(layer:int):
	for r in range(0,rows):
		spawn_placement_nodes_row(r, layer)
		if (r + 0.5 < rows):
			spawn_placement_nodes_row(r+0.5, layer)
	bGenerated = true
	pass

func spawn_placement_nodes_row(cur_row,layer):
	for c in range (0, cols):
			place_node(cur_row, c, layer)
			if (c + 0.5 < cols):
				#spawn halfstep node
				place_node(cur_row, c+0.5, layer)
	pass

func place_node(r, c, layer):
	var new_hs_node = placement_node_scn.instance()
	new_hs_node.position = Vector2(r,c)
	new_hs_node.layer = layer
	new_hs_node.translation = Vector3(r*nodes_distance_height, layer*nodes_distance_depth, c*nodes_distance_width)
	$Layout.add_child(new_hs_node)
