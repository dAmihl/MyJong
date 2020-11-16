extends Spatial

var board = []
var hints = []

var paused: bool = false
onready var gamestats = $"/root/Board/GameStatistics"
signal game_win
signal game_over
signal clear_done



func _ready():
	gamestats.set_tiles_left(board.size())
	print("Gameboard ready")

func add_tile(tile):
	board.append(tile)
	call_deferred("add_child", tile)
	pass

func board_ready():
	print("Number Tiles: "+ str(board.size()))
#	calculate_hints()
	unpause_board()
	if (is_instance_valid(gamestats)):
		gamestats.set_tiles_left(board.size())

func remove_tile(tile):
	board.erase(tile)
	calculate_hints()
	gamestats.set_tiles_left(board.size())
	check_state()

	
func check_state():
	if board.size() == 0:
		on_win()
		return
	if hints.size() == 0:
		on_no_moves()
		return

func get_perfect_hint():
	var b = board[board.size()-1]
	var b2 = board[board.size()-2]
	b.hint_highlight()
	b2.hint_highlight()

func get_random_hint() -> Array:
	calculate_hints()
	if hints.size() == 0:
		return []
	var hint_idx = randi() % hints.size()
	var hint = hints[hint_idx]
	var b = hint[0]
	var b2 = hint[1]
	return hint

func get_smart_hint() -> Array:
	var b = board[0]
	var b2 = board[1]
	b.hint_highlight()
	b2.hint_highlight()
	return [b, b2]

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
			c.free()
	emit_signal("clear_done")

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
	
func on_win():
	print("Win!")
	emit_signal("game_win", gamestats.points, gamestats.time_passed, gamestats.hints_used, gamestats.moves)
	pass
	
func on_no_moves():
	print("No more moves!")
	#emit_signal("game_over", gamestats.points, gamestats.time_passed, gamestats.hints_used, gamestats.moves)
	pass

func undo(tile1, tile2):
	add_tile(tile1)
	add_tile(tile2)
	gamestats.set_tiles_left(board.size())
