extends Spatial

var layout_tile_scn = preload("res://Scenes/LayoutEditor/LayoutTile.tscn")


		
func on_place_node(node:Spatial):
	print("Node clicked")
	var new_tile = layout_tile_scn.instance()
	new_tile.translation = node.translation
	new_tile.position = node.position
	new_tile.layer = node.layer
	add_child(new_tile)
	new_tile.connect("layout_tile_removed", $"../PlacementGrid", "on_remove_node")
	pass

