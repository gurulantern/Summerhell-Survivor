extends Area2D

@export var value = 5
@export var snd_collected : AudioStreamWAV
@export var snd_volume : float

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func collect():
	var sfx = SoundManager.play_sound(snd_collected)
	sfx.volume_db = snd_volume
	collision.set_deferred("disabled", true)
	sprite.visible = false
	return value

func _on_snd_collected_finished():
	queue_free()
