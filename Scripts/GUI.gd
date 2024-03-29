extends Control

# It seems best that GUI is the first child in the scene
# because nothing should be dependant on GUI, whereas GUI is dependant on
# e.g. GameStatistics to initialize the data. With the signal the GUI needs 
#  to be ready whenever this happens.
# Since Godot calls _ready bottom - top, GUI needs to be higher than e.g.
# GameStatistics

onready var score_data = find_node("ScoreData")
onready var moves_data = find_node("MovesData")
onready var time_data = find_node("TimeData")
onready var tiles_left_data = find_node("TilesLeftData")

signal restart_btn
signal pause_btn
signal hint_btn
signal undo_btn
signal home_btn
signal shuffle_btn

func _on_GameStatistics_stats_hints_used_changed(h):
	pass # Replace with function body.


func _on_GameStatistics_stats_moves_changed(m):
	#moves_data.text = str(m)
	pass # Replace with function body.


func _on_GameStatistics_stats_points_changed(p):
	score_data.text = str(p)
	pass # Replace with function body.


func _on_GameStatistics_stats_time_passed(t:int):
	var minutes = t / 60
	var seconds = t % 60
	#time_data.text = str(minutes)+":"+("%02d"%seconds)
	pass # Replace with function body.


func _on_GameStatistics_stats_tiles_left_changed(tl):
	tiles_left_data.text = str(tl)
	pass # Replace with function body.


func _on_RestartButton_pressed():
	emit_signal("restart_btn")
	pass # Replace with function body.


func _on_PauseButton_pressed():
	emit_signal("pause_btn")
	pass # Replace with function body.


func _on_HintButton_pressed():
	emit_signal("hint_btn")
	pass # Replace with function body.


func _on_UndoButton_pressed():
	emit_signal("undo_btn")
	pass # Replace with function body.


func _on_HomeButton_pressed():
	emit_signal("home_btn")
	pass # Replace with function body.


func _on_ShuffleButton_pressed():
	emit_signal("shuffle_btn")
	pass # Replace with function body.
