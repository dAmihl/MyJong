extends Control

const customLayoutDirPath:String = "user://"

onready var item_list = find_node("ItemList")
onready var modes_list = find_node("GamemodeList")

var texIconPreset = preload("res://assets/ui/icons/PNG/White/1x/contrast.png")
var texIconCustom = preload("res://assets/ui/icons/PNG/White/1x/gear.png")

func _ready():
	load_gamemodes()
	load_layouts()
	pass

func load_layouts():
	var layouts = LayoutManager.load_preset_layouts()
	for l in layouts:
		add_layout(l, texIconPreset)
	
	var customLayouts = LayoutManager.load_custom_layouts()
	for l in customLayouts:
		add_layout(l, texIconCustom)

func load_gamemodes():
	var modes = GameModeManager.load_preset_gamemodes()
	for m in modes:
		add_gamemode(m, texIconPreset)
	modes_list.select(0) #preselect the first one

func add_layout(l:LayoutManager.Layout, icon:Texture = texIconPreset):
	item_list.add_item(l.layout_name, icon)
	item_list.set_item_metadata(item_list.get_item_count()-1, l)
	pass

func add_gamemode(m:GameModeManager.GameMode, icon:Texture = texIconPreset):
	modes_list.add_item(m.gamemode_name, icon)
	modes_list.set_item_metadata(modes_list.get_item_count()-1, m)
	pass

func _on_PlayButton_pressed():
	var layouts = item_list.get_selected_items()
	if layouts.size() == 0:
		return
	var first_layout_idx = layouts[0]
	start_play_item_index(first_layout_idx)
	pass # Replace with function body.


func start_play_item_index(index:int):
	var text = item_list.get_item_text(index)
	var metadata:LayoutManager.Layout = item_list.get_item_metadata(index)
	var layoutPath = metadata.layout_full_path
	
	var mode:GameModeManager.GameMode = modes_list.get_item_metadata(modes_list.get_selected_items()[0])
	SceneManager.change_scene("Levels/Generated.tscn", {"layout_data":metadata.layout_data, "gamemode":mode})
	pass

func _on_ItemList_item_activated(index):
	start_play_item_index(index)
	pass # Replace with function body.


func _on_EditorButton_pressed():
	SceneManager.change_scene("Levels/LayoutEditor.tscn")
	pass # Replace with function body.


func _on_GamemodeList_item_activated(index):
	pass # Replace with function body.
