extends Node2D

@export var score : AudioStreamWAV

@onready var grass1 = $Grass1
@onready var grass2 = $Grass2
@onready var grass3 = $Grass3
@onready var player = $Heesoo

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
	

func treadmill(current_grass: TileMap, new_grass: TileMap):
	current_grass.set_layer_z_index(0, -2)
	new_grass.set_layer_z_index(0, -3)
	new_grass.global_position = player.position

func _on_grass1_body_exited(body):
	print("Heesoo exited 1")
	treadmill(grass1, grass2)

func _on_grass2_body_exited(body):
	print("Heesoo exited 2")
	treadmill(grass2, grass3)

func _on_grass3_body_exited(body):
	print("Heesoo exited 3")
	treadmill(grass3, grass1)
