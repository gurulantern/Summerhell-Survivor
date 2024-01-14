extends Control

@export var dialogue_json: JSON

# Use this for conditionals and pass through start_dialogue()
@onready var state = {
	show_only_one = true
} 

@onready var prompt = get_node("%Prompt")
@onready var dialogue_button = preload("res://Utility/UI/dialogue_button.tscn")
@onready var content = $Panel/Content
var choice_buttons: Array[Button]=[]

func _ready():
	($EzDialogue as EzDialogue).start_dialogue(dialogue_json, state)

func clear_dialogue_box():
	prompt.text = ""
	for choice in choice_buttons:
		choice.queue_free()
	choice_buttons = []


func add_text(text:String):
	prompt.text = text

func add_choice(choice_text:String):
	var button_obj = dialogue_button.instantiate() as DialogueButton
	button_obj.choice_index = choice_buttons.size()
	choice_buttons.push_back(button_obj)
	button_obj.text = choice_text
	button_obj.choice_selected.connect(_on_choice_selected)
	content.add_child(button_obj)

func _on_choice_selected(choice_index: int):
	print(choice_index)
	$EzDialogue.next(choice_index)

func _on_ez_dialogue_dialogue_generated(response: DialogueResponse):
	clear_dialogue_box()
	
	add_text(response.text)
	for choice in response.choices:
		add_choice(choice)
