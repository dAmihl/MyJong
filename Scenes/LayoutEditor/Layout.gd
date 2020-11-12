extends Spatial

func export_layout():
	var export_str:String = ""
	var layers = {}
	for node in get_children():
		if !node.is_tile_set:
			continue
		var l = node.layer
		if !(layers.has(l)):
			layers[l] = []
		layers[l].append([node.position.x, node.position.y])
	print(JSON.print(layers))


func _input(event):
	if event.is_action_pressed("export_layout"):
		export_layout()
