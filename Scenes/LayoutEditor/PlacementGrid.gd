extends Spatial

func export_layout() -> String:
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
	print(JSON.print(layers_arr))
	return JSON.print(layers_arr)



