extends WindowDialog

signal save_layout

onready var input_name = find_node("InputName")
onready var input_author = find_node("InputAuthor")
onready var input_desc = find_node("InputDescription")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SaveDialogButton_pressed():
	emit_signal("save_layout", input_name.text, input_author.text, input_desc.text)
	self.hide()
	pass # Replace with function body.
