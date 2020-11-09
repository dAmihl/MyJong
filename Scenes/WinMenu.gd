extends MarginContainer

onready var points_data = find_node("PointsData")
onready var moves_data = find_node("MovesData")
onready var time_data = find_node("TimeData")
onready var hints_data = find_node("HintsData")

func set_points(p):
	points_data.text = str(p)
	pass

func set_moves(m):
	moves_data.text = str(m)
	pass

func set_time(t:int):
	var minutes = t / 60
	var seconds = t % 60
	time_data.text = str(minutes)+":"+("%02d"%seconds)
	pass

func set_hints(h):
	hints_data.text = str(h)
	pass


func _on_QuitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_NewButton_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
