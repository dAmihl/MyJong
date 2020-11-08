extends Spatial

var board = []
var hints = []

func add_tile(tile, pos, layer):
	board.append(tile)
	add_child(tile)
	pass

func board_ready():
	print("Number Tiles: "+ str(board.size()))
	calculate_hints()

func remove_tile(tile):
	board.erase(tile)
	calculate_hints()
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
	var hint = hints[0]
	var b = hint[0]
	var b2 = hint[1]
	b.hint_highlight()
	b2.hint_highlight()
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
	hints.clear()
	board.clear()
	for c in get_children():
		self.remove_child(c)


