extends Spatial

func export_layout() -> Array:
	var export_str:String = ""
	var layers = {}
	for node in get_children():
		for t in node.get_tiles():
			var l = t.layer
			if !(layers.has(l)):
				layers[l] = []
			layers[l].append([t.position.x, t.position.y])
	var layers_arr = []
	for k in layers:
		layers_arr.append(layers.get(k))
	return layers_arr
	
func _on_Tile_Placed(tile:Spatial):
	update_layers_of_neighbours(tile, false)
	pass
	
func _on_Tile_Removed(tile:Spatial):
	update_layers_of_neighbours(tile, true)
	pass

func update_layers_of_neighbours(node:Spatial, enabled:bool = false):
	pass
	
func get_neighbours_of_node(node:Spatial) -> Array:
	var tile_pos = node.position
	var neighbours = []
	for t in get_children():
		var t_pos = t.position
		if t == node:
			continue
		if (abs(t_pos.x - tile_pos.x) <= 0.5 and
		abs(t_pos.y - tile_pos.y) <= 0.5):
			neighbours.append(t)
	return neighbours
