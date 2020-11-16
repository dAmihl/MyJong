extends Control

signal load_file_selected
signal save_file_selected

onready var numTilesData = find_node("TilesData")
onready var saveButton = find_node("SaveButton")

var numberTiles = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_LoadButton_pressed():
	$LoadDialog.popup()
	pass # Replace with function body.


func _on_SaveButton_pressed():
	$SaveDialog.popup()
	pass # Replace with function body.

func _on_LoadDialog_file_selected(path):
	emit_signal("load_file_selected",path)
	pass # Replace with function body.


func _on_SaveDialog_file_selected(path):
	emit_signal("save_file_selected", path)
	pass # Replace with function body.


func _on_LayoutEditor_num_tiles_changed(numTiles:int):
	numberTiles = numTiles
	numTilesData.text = str(numTiles)
	saveButton.disabled = numberTiles % 2 == 1
	pass # Replace with function body.
