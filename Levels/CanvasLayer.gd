extends CanvasLayer


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
