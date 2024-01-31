extends Control

var levelOne = "res://Scenes/Levels/levelOne.tscn"

func _ready():
	print("Loaded Main Menu")
#$PlayButton.grab_focus()

func _on_play_button_click_end():
	SaverLoader.load_game()
	SceneSwitcher.switch_scene(levelOne)

func _on_exit_button_click_end():
	print("Quitting")
	get_tree().quit()
