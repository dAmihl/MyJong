extends CanvasLayer

var win_scn = preload("res://Scenes/WinMenu.tscn")

func _on_Controls_pause_game():
	$GUI.visible = false
	$PauseMenu.visible = true
	pass # Replace with function body.


func _on_Controls_unpause_game():
	$GUI.visible = true
	$PauseMenu.visible = false
	pass # Replace with function body.


func _on_PauseMenu_new_game():
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_PauseMenu_restart_game():
	$"/root/Board/Controls".pause_game()
	$"/root/Board/Controls".restart_board()
	$GUI.visible = true
	$PauseMenu.visible = false
	pass # Replace with function body.


func _on_PauseMenu_resume_game():
	$"/root/Board/Controls".pause_game()
	_on_Controls_unpause_game()
	pass # Replace with function body.


func _on_PauseMenu_quit_game():
	get_tree().quit()
	pass # Replace with function body.


func _on_GUI_pause_btn():
	$"/root/Board/Controls".pause_game()
	pass # Replace with function body.


func _on_GUI_restart_btn():
	$"/root/Board/Controls".restart_board()
	pass # Replace with function body.


func _on_GameBoard_game_win(points,time,hints,moves):
	self.remove_child($GUI)
	self.remove_child($PauseMenu)
	var win_gui = win_scn.instance()
	self.add_child(win_gui)
	win_gui.set_points(points)
	win_gui.set_time(time)
	win_gui.set_hints(hints)
	win_gui.set_moves(moves)
	win_gui.set_won(true)
	pass # Replace with function body.


func _on_GameBoard_game_over(points,time,hints,moves):
	self.remove_child($GUI)
	self.remove_child($PauseMenu)
	var win_gui = win_scn.instance()
	self.add_child(win_gui)
	win_gui.set_points(points)
	win_gui.set_time(time)
	win_gui.set_hints(hints)
	win_gui.set_moves(moves)
	win_gui.set_won(false)
	pass # Replace with function body.
