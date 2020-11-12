extends Spatial

var layer:int = 0

func export_layer_array() -> Array:
	var return_arr = []
	for node in get_children():
		if !node.is_tile_set:
			continue
		return_arr.append([node.position.x, node.position.y])
	return return_arr

func hide_handles(hide:bool = true):
	for c in get_children():
		c.toggle_handle(!hide)
