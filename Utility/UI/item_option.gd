extends ColorRect

var mouse_over = false
var item = null

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label_name = $LabelName
@onready var label_description = $LabelDescription
@onready var label_level = $LabelLevel
@onready var item_icon = $ColorRect/ItemIcon

@export var snd_hover : AudioStreamWAV
@export var snd_pressed : AudioStreamWAV

signal selected_upgrade(upgrade)


func _ready():
	#Connects the signal declared here to Hee Soo and calls her upgrade function
	connect("selected_upgrade", Callable(player,"upgrade_heesoo"))
	if item == null:
		item = "sashimi"
	label_name.text = UpgradeDb.UPGRADES[item]["displayname"]
	label_description.text = UpgradeDb.UPGRADES[item]["details"]
	label_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

func _input(event):
	if event.is_action("click"):
		if mouse_over:
			SoundManager.play_ui_sound(snd_pressed)
			emit_signal("selected_upgrade", item)

func _on_mouse_entered():
	SoundManager.play_ui_sound(snd_hover)
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
