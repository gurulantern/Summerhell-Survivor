extends Node2D

@export var score : AudioStreamWAV
var stream_player : AudioStreamPlayer

func _ready():
	stream_player = play_score()

func play_score() -> AudioStreamPlayer:
	var streamer = SoundManager.play_music(score)
	return streamer

func set_score(music : AudioStreamWAV):
	score = music

func _on_heesoo_player_death():
	SoundManager.pause_music(score)
