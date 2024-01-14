class_name DialogueButton extends Button

var choice_index: int

signal choice_selected(choice_index)

func _on_pressed():
	$snd_click.play()
	choice_selected.emit(choice_index)

signal click_end()

func _on_mouse_entered():
	$snd_hover.play()

func _on_snd_click_finished():
	emit_signal("click_end")

func _on_focus_entered():
	$snd_hover.play()
