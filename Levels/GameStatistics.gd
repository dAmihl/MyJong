extends Spatial

var moves:int = 0 setget set_moves
var hints_used:int = 0 setget set_hints_used
var time_passed:float = 0 setget set_time_passed
var points:int = 0 setget set_points

signal stats_moves_changed
signal stats_hints_used_changed
signal stats_points_changed
signal stats_time_passed

func _ready():
	clear_data()

func add_move():
	set_moves(moves+1)
	
func add_hint_used():
	set_hints_used(hints_used+1)

func add_points(p:int):
	set_points(points+p)

func add_time_passed_second():
	set_time_passed(time_passed+1)

func set_moves(m):
	moves = m
	emit_signal("stats_moves_changed", moves)
	
func set_hints_used(h):
	hints_used = h
	emit_signal("stats_hints_used_changed", hints_used)
	
func set_time_passed(t):
	time_passed = t
	emit_signal("stats_time_passed", time_passed)

func set_points(p):
	points = p
	emit_signal("stats_points_changed", points)

func clear_data():
	set_moves(0)
	set_hints_used(0)
	set_time_passed(0)
	set_points(0)
