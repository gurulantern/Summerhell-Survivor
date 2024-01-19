class_name DialogueButton extends Button

var choice_index: int
@export var snd_hover : AudioStreamWAV
@export var snd_click : AudioStreamWAV

signal choice_selected(choice_index)
signal click_end()

func _on_pressed():
	var streamer = SoundManager.play_ui_sound(snd_click)
	streamer.finished.connect(_on_snd_click_finished)
	choice_selected.emit(choice_index)

func _on_mouse_entered():
	SoundManager.play_ui_sound(snd_hover)

func _on_snd_click_finished():
	emit_signal("click_end")

func _on_focus_entered():
	SoundManager.play_ui_sound(snd_hover)
