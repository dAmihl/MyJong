extends Spatial

var board = []
var hints = []

var paused: bool = false
onready var gamestats = $"../GameStatistics"
var gamemode:GameModeManager.GameMode setget set_gamemode

signal game_win
signal game_over
signal clear_done

var num_hints_available:int = 0
var num_undo_available:int = 0
var num_shuffle_available: int = 0

var last_removed_tiles = []

func _ready():
	gamestats.set_tiles_left(board.size())
	print("Gameboard ready")

func set_gamemode(gm:GameModeManager.GameMode):
	gamemode = gm
	num_hints_available = gm.hint_number
	num_undo_available = gm.undo_number
	num_shuffle_available = gm.shuffle_number

func add_tile(tile):
	board.append(tile)
	call_deferred("add_child", tile)
	pass

func board_ready():
	print("Number Tiles: "+ str(board.size()))
	unpause_board()
	if (is_instance_valid(gamestats)):
		gamestats.set_tiles_left(board.size())

func remove_tile(tile):
	board.erase(tile)
	#calculate_hints()
	gamestats.set_tiles_left(board.size())
	check_state()
	
func check_state():
	if board.size() == 0:
		on_win()
		return
	if hints.size() == 0:
		on_no_moves()
		return
	
func is_hint_available() -> bool:
	return num_hints_available > 0 or num_hints_available == -1
	
func is_shuffle_available() -> bool:
	return num_shuffle_available > 0 or num_shuffle_available == -1
	
func is_undo_available() -> bool:
	return num_undo_available > 0 or num_undo_available == -1



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
	last_removed_tiles.clear()
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

func get_hint():
	if is_hint_available():
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
		# could also be -1 for infinite
		if num_hints_available > 0:
			num_hints_available -= 1
		return hint
	else:
		print("No Hint available.")
		return

func undo():
	if is_undo_available():
		if last_removed_tiles.size() > 0:
			var last_pair = last_removed_tiles.back()
			var tile1 = last_pair[0]
			var tile2 = last_pair[1]
			add_tile(tile1)
			add_tile(tile2)
			gamestats.set_tiles_left(board.size())
			last_removed_tiles.erase(last_pair)
			# could also be -1 for infinite
			if num_undo_available > 0:
				num_undo_available -= 1
		else:
			print("No Moves to undo!")
			return
	else:
		print("No undo available.")
		return

func shuffle():
	if is_shuffle_available():
		for b in board:
			var randIndx = randi() % board.size()
			var b2:StaticBody = board[randIndx]
			if b == b2: continue
			var t1 = b.transform
			var t2 = b2.transform
			b.transform = t2
			b2.transform = t1
			# could also be -1 for infinite
		if num_shuffle_available > 0:
				num_shuffle_available -= 1
	else:
		print("No Shuffle available.")
		return
		
