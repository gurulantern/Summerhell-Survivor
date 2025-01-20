extends Panel

var is_paused = false


signal pause_game
signal unpause_game

func _input(event):
	if event.is_action_pressed("Pause"):
		if is_paused:
			is_paused = false
			emit_signal("unpause_game")
		else:
			is_paused = true
			emit_signal("pause_game")
