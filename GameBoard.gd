extends Spatial

var board = []
var hints = []

var paused: bool = false
onready var gamestats = $"/root/Board/GameStatistics"

func _ready():
	gamestats.set_tiles_left(board.size())

func add_tile(tile, pos, layer):
	board.append(tile)
	add_child(tile)
	pass

func board_ready():
	print("Number Tiles: "+ str(board.size()))
	calculate_hints()
	unpause_board()
	if (is_instance_valid(gamestats)):
		gamestats.set_tiles_left(board.size())

func remove_tile(tile):
	board.erase(tile)
	calculate_hints()
	gamestats.set_tiles_left(board.size())
	check_move()
	check_win()
	
func check_win():
	if board.size() == 0:
		print("WIN!!")

func check_move():
	if hints.size() == 0:
		#print("No Moves Left!!")
		pass

func get_perfect_hint():
	var b = board[board.size()-1]
	var b2 = board[board.size()-2]
	b.hint_highlight()
	b2.hint_highlight()

func get_random_hint() -> Array:
	calculate_hints()
	if hints.size() == 0:
		print("no hints")
		return []
	var hint_idx = randi() % hints.size()
	var hint = hints[hint_idx]
	var b = hint[0]
	var b2 = hint[1]
	b.hint_highlight()
	b2.hint_highlight()
	return hint

func get_hint() -> Array:
	calculate_hints()
	if hints.size() == 0:
		print("no hints")
		return []
	var hint = hints[0]
	var b = hint[0]
	var b2 = hint[1]
	b.hint_highlight()
	b2.hint_highlight()
	gamestats.add_hint_used()
	return hint

func calculate_hints():
	hints.clear()
	for b in board:
		if !b.is_free():
			continue
		else:
			for b2 in board:
				if b == b2:
					continue
				if (!b2.is_free()):
					continue
				if TileType.types_match(b.type, b2.type):
					hints.append([b, b2])

func clear():
	pause_board()
	hints.clear()
	board.clear()
	for c in get_children():
		if c.is_in_group("tiles"):
			self.remove_child(c)

func is_paused():
	return paused

func pause_board():
	get_tree().call_group("controllables", "set_process_input", false)
	pause_timer()
	paused = true

func unpause_board():
	get_tree().call_group("controllables", "set_process_input", true)
	start_timer()
	paused = false

func start_timer():
	$GameTimer.start()
	
func pause_timer():
	$GameTimer.stop()

func _on_GameTimer_timeout():
	gamestats.add_time_passed_second()
	pass # Replace with function body.
