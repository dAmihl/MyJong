extends Control

const layoutDirPath:String = "user://"

onready var item_list = find_node("ItemList")

func _ready():
	load_layouts()
	pass

func load_layouts():
	dir_contents("user://")
	pass

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				item_list.add_item(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func _on_PlayButton_pressed():
	var layouts = item_list.get_selected_items()
	if layouts.size() == 0:
		return
	var first_layout_idx = layouts[0]
	start_play_item_index(first_layout_idx)
	pass # Replace with function body.


func start_play_item_index(index:int):
	var first_layout_text = item_list.get_item_text(index)
	var first_layout_metadata = item_list.get_item_metadata(index)
	var layoutPath = layoutDirPath+first_layout_text
	SceneManager.change_scene("Levels/Generated.tscn", {"layout_path":layoutPath})
	pass

func _on_ItemList_item_activated(index):
	start_play_item_index(index)
	pass # Replace with function body.


func _on_EditorButton_pressed():
	SceneManager.change_scene("Levels/LayoutEditor.tscn")
	pass # Replace with function body.
