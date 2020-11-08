
extends CanvasLayer

# It seems best that GUI is the first child in the scene
# because nothing should be dependant on GUI, whereas GUI is dependant on
# e.g. GameStatistics to initialize the data. With the signal the GUI needs 
#  to be ready whenever this happens.
# Since Godot calls _ready bottom - top, GUI needs to be higher than e.g.
# GameStatistics

onready var points_data = find_node("PointsData")
onready var moves_data = find_node("MovesData")
onready var time_data = find_node("TimeData")

func _on_GameStatistics_stats_hints_used_changed(h):
	pass # Replace with function body.


func _on_GameStatistics_stats_moves_changed(m):
	moves_data.text = str(m)
	pass # Replace with function body.


func _on_GameStatistics_stats_points_changed(p):
	points_data.text = str(p)
	pass # Replace with function body.


func _on_GameStatistics_stats_time_passed(t):
	time_data.text = str(t)
	pass # Replace with function body.
