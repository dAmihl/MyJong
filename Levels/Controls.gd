extends Spatial

onready var gameboard = $"../GameBoard"
onready var gamestats = $"../GameStatistics"
var selection

signal pause_game
signal unpause_game



var audio_clicks = [
	preload("res://assets/ui/Bonus/click1.ogg"), 
	preload("res://assets/ui/Bonus/click2.ogg")
]

var audio_locked = [
	preload("res://assets/ui/Bonus/rollover2.ogg")
]

var audio_clear = [
	preload("res://assets/fremd/life_pickup.ogg")
]

func _input(event):
	if event.is_action_pressed("pause"):
		pause_game()
		return
	if gameboard.paused:
		return
	if event.is_action_pressed("autosolve"):
		$"../LayoutGenerator".try_solve_bruteforce()

func tile_clicked(block):
	if gameboard.is_paused():
		return
	if !is_instance_valid(selection):
		select_block(block)
		$AudioClick.stream = audio_clicks[0]
		$AudioClick.play()
		return
	else:
		if selection == block:
			deselect_block(selection)
			$AudioClick.stream = audio_clicks[1]
			$AudioClick.play()
		else:
			eval_selection(selection,block)
	return

func tile_not_free_clicked(tile):
	$AudioClick.stream = audio_locked[0]
	$AudioClick.play()

func select_block(block):
	selection = block
	block.selected()
	return
	
func deselect_block(block):
	block.deselected()
	selection = null
	return
	
func remove_block(block):
	block.remove()
	gameboard.remove_tile(block)
	selection=null
	return
	
func remove_tile_pair(tile1, tile2):
	remove_block(tile1)
	remove_block(tile2)
	gameboard.last_removed_tiles.append([tile1, tile2])
	
func eval_selection(sel1, sel2):
	if (TileType.types_match(sel1.type, sel2.type)):
		gamestats.add_move()
		gamestats.add_points(150)
		remove_tile_pair(sel1, sel2)
		$AudioClick.stream = audio_clear[0]
		$AudioClick.play()
	else:
		deselect_block(sel1)
		select_block(sel2)
		$AudioClick.stream = audio_clicks[0]
		$AudioClick.play()

func pause_game():
	if !gameboard.is_paused():
		emit_signal("pause_game")
		get_tree().paused = true
		gameboard.pause_board()
		clear_selection()
	else:
		emit_signal("unpause_game")
		gameboard.unpause_board()
		get_tree().paused = false

func clear_selection():
	if is_instance_valid(selection):
		deselect_block(selection)

func restart_board():
	selection = null
	$"../LayoutGenerator".restart()
	
func undo():
	gameboard.undo()
	
func hint():
	gameboard.get_hint()

