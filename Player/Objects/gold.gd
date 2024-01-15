extends Area2D

@export var value = 5

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var snd_collected = $snd_collected

func collect():
	snd_collected.play()
	collision.set_deferred("disabled", true)
	sprite.visible = false
	return value

func _on_snd_collected_finished():
	queue_free()
