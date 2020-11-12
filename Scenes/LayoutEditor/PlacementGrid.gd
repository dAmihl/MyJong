extends Spatial

func export_layout():
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


func _input(event):
	if event.is_action_pressed("export_layout"):
		export_layout()
