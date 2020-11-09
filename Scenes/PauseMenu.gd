extends MarginContainer

signal resume_game
signal restart_game
signal new_game
signal quit_game

func _on_ResumeButton_pressed():
	emit_signal("resume_game")
	print("resume")
	pass # Replace with function body.


func _on_RestartButton_pressed():
	emit_signal("restart_game")
	pass # Replace with function body.


func _on_NewButton_pressed():
	emit_signal("new_game")
	pass # Replace with function body.


func _on_QuitButton_pressed():
	emit_signal("quit_game")
	pass # Replace with function body.
