extends Control

var level = "res://Scenes/level.tscn"

func _ready():
	$PlayButton.grab_focus()

func _on_play_button_click_end():
	SaverLoader.load_game()
	var _level = get_tree().change_scene_to_file(level)

func _on_exit_button_click_end():
	get_tree().quit()
