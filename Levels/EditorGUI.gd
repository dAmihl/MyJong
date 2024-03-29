extends Control

signal load_file_selected
signal home_btn
signal clear_btn
signal new_btn

onready var numTilesData = find_node("TilesData")
onready var saveButton = find_node("SaveButton")

var numberTiles = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	saveButton.disabled = numberTiles % 2 == 1 or numberTiles == 0

func _on_LoadButton_pressed():
	$LoadDialog.popup()
	pass # Replace with function body.


func _on_SaveButton_pressed():
	$SaveDialog.popup()
	pass # Replace with function body.

func set_current_layout(l:LayoutManager.Layout):
	$SaveDialog/MarginContainer/VBoxContainer/Name/InputName.text = l.layout_name
	$SaveDialog/MarginContainer/VBoxContainer/Author/InputAuthor.text = l.author
	$MarginContainer/VBoxContainer/Top/MarginContainer/CenterContainer/CurrentLayoutName.text = l.layout_name

func clear_current_layout():
	$SaveDialog/MarginContainer/VBoxContainer/Name/InputName.text = ""
	$SaveDialog/MarginContainer/VBoxContainer/Author/InputAuthor.text = "Default"
	$MarginContainer/VBoxContainer/Top/MarginContainer/CenterContainer/CurrentLayoutName.text = ""

func _on_LayoutEditor_num_tiles_changed(numTiles:int):
	numberTiles = numTiles
	numTilesData.text = str(numTiles)
	
	pass # Replace with function body.


func _on_HomeButton_pressed():
	emit_signal("home_btn")
	pass # Replace with function body.


func _on_LoadDialog_load_layout(path):
	emit_signal("load_file_selected",path)
	pass # Replace with function body.


func _on_ClearButton_pressed():
	emit_signal("clear_btn")
	pass # Replace with function body.


func _on_NewButton_pressed():
	emit_signal("new_btn")
	pass # Replace with function body.
