extends Spatial

func export_layout():
	var export_str:String = ""
	var layers = {}
	for l in get_children():
		var lNum = l.layer
		layers[lNum] = l.export_layer_array()
	var layers_arr = []
	for k in layers:
		layers_arr.append(layers.get(k))
	print(JSON.print(layers_arr))


func _input(event):
	if event.is_action_pressed("export_layout"):
		export_layout()
