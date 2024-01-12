extends Control


@onready var prompt = get_node("%Prompt")
@onready var dialogue_button = preload("res://Utility/UI/dialogue_button.tscn")

func add_text(text:String):
	prompt.text = text

func add_choice(choice_text:String):
	
