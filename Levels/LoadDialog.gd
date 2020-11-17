extends WindowDialog

onready var item_list = find_node("ItemList")
onready var load_btn = find_node("LoadDialogButton")

signal load_layout

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	load_btn.disabled = !item_list.is_anything_selected()

func _on_LoadDialog_about_to_show():
	item_list.clear()
	load_layouts()
	pass # Replace with function body.
	
func load_layouts():
	var customLayouts = LayoutManager.load_custom_layouts()
	for l in customLayouts:
		add_layout(l)

func add_layout(l:LayoutManager.Layout, icon:Texture = null):
	item_list.add_item(l.layout_name, icon)
	item_list.set_item_metadata(item_list.get_item_count()-1, l)
	pass

func _on_LoadDialogButton_pressed():
	var layouts = item_list.get_selected_items()
	if layouts.size() == 0:
		return
	var index = layouts[0]
	load_layout_by_index(index)
	pass # Replace with function body.

func load_layout_by_index(index):
	var text = item_list.get_item_text(index)
	var metadata:LayoutManager.Layout = item_list.get_item_metadata(index)
	var layoutPath = metadata.layout_full_path
	emit_signal("load_layout", layoutPath)
	hide()

func _on_ItemList_item_activated(index):
	load_layout_by_index(index)
	pass # Replace with function body.
