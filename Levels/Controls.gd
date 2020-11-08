extends Spatial

onready var gameboard = $"/root/Board/GameBoard"
onready var gamestats = $"/root/Board/GameStatistics"
var selection

signal pause_game
signal unpause_game

func _input(event):
	if event.is_action_pressed("pause"):
		pause_game()
		return
	if gameboard.paused:
		return
	if event.is_action_pressed("hint"):
		gameboard.get_hint()
	if event.is_action_pressed("autosolve"):
		$"../LayoutGenerator".try_solve_bruteforce()
	if event.is_action_pressed("restart"):
		restart_board()

func block_clicked(block):
	if gameboard.is_paused():
		return
	if !is_instance_valid(selection):
		select_block(block)
		return
	else:
		if selection == block:
			deselect_block(selection)
		else:
			eval_selection(selection,block)
	return
	
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
	
func eval_selection(sel1, sel2):
	if (TileType.types_match(sel1.type, sel2.type)):
		remove_block(sel1)
		remove_block(sel2)
		gamestats.add_move()
		gamestats.add_points(150)
	else:
		deselect_block(sel1)
		select_block(sel2)

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
