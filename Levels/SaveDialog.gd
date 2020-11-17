extends WindowDialog

signal save_layout

onready var input_name = find_node("InputName")
onready var input_author = find_node("InputAuthor")
onready var input_desc = find_node("InputDescription")

onready var save_btn = find_node("SaveDialogButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	input_name.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	save_btn.disabled = (input_name.text.length() == 0 or input_author.text.length() == 0)
	pass


func _on_SaveDialogButton_pressed():
	emit_signal("save_layout", input_name.text, input_author.text, input_desc.text)
	self.hide()
	pass # Replace with function body.



func _on_SaveDialog_about_to_show():
	input_name.grab_click_focus()
	pass # Replace with function body.
