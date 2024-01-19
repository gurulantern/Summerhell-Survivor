extends Button

@export var snd_hover : AudioStreamWAV
@export var snd_click : AudioStreamWAV

signal click_end()

func _on_mouse_entered():
	SoundManager.play_ui_sound(snd_hover)

func _on_pressed():
	var streamer = SoundManager.play_ui_sound(snd_click)
	streamer.finished.connect(_on_snd_click_finished)

func _on_snd_click_finished():
	print("Emitting click end")
	emit_signal("click_end")

func _on_focus_entered():
	SoundManager.play_ui_sound(snd_hover)
