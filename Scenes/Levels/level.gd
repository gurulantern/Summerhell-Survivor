extends Node2D

@export var score : AudioStreamWAV

@onready var player = $Heesoo
@onready var leap_frogger = get_node("TilemapTreadmill/LeapFrogger")

@onready var grass1 : TileMap = get_node("TilemapTreadmill/Grass1")
@onready var grass2 : TileMap = get_node("TilemapTreadmill/Grass2")
@onready var grass3 : TileMap = get_node("TilemapTreadmill/Grass3")
@onready var grass4 : TileMap = get_node("TilemapTreadmill/Grass4")
@onready var grass5 : TileMap = get_node("TilemapTreadmill/Grass5")
@onready var grass6 : TileMap = get_node("TilemapTreadmill/Grass6")
@onready var grass7 : TileMap = get_node("TilemapTreadmill/Grass7")
@onready var grass8 : TileMap = get_node("TilemapTreadmill/Grass8")
@onready var grass9 : TileMap = get_node("TilemapTreadmill/Grass9")

@onready var grass_matrix = [
	[grass1, grass2, grass3],
	[grass4, grass5, grass6],
	[grass7, grass8, grass9]
]

var tile_map_size : Vector2i

var stream_player : AudioStreamPlayer

func _ready():
	tile_map_size = grass1.get_used_rect().size * 16
	print(tile_map_size)
	stream_player = play_score()

func play_score() -> AudioStreamPlayer:
	var streamer = SoundManager.play_music(score)
	return streamer

func set_score(music : AudioStreamWAV):
	score = music

func _on_heesoo_player_death():
	SoundManager.pause_music(score)

func move_tiles(direction: String):
	match direction:
		"north":
			for i in grass_matrix[2]:
				i.position.y = i.position.y - (3 * tile_map_size.y)
			grass_matrix.insert(0, grass_matrix[2])
			grass_matrix.pop_back()
			for i in grass_matrix:
				for j in i:
					print(j)
		"east":
			for i in grass_matrix:
				i[0].position.x = i[0].position.x + (3 * tile_map_size.x)
				i.insert(3, i[0])
				i.pop_front()
			for i in grass_matrix:
				for j in i:
					print(j)
		"west":
			for i in grass_matrix:
				i[2].position.x = i[2].position.x - (3 * tile_map_size.x)
				i.insert(0, i[2])
				i.pop_back()
			for i in grass_matrix:
				for j in i:
					print(j)
		"south":
			for i in grass_matrix[0]:
				i.position.y = i.position.y + (3 * tile_map_size.y)
			grass_matrix.insert(3, grass_matrix[0])
			grass_matrix.pop_front()
			for i in grass_matrix:
				for j in i:
					print(j)
	move_leapfrogger(direction)
	pass

func move_leapfrogger(direction: String):
	match direction:
		"north":
			leap_frogger.position.y = leap_frogger.position.y - tile_map_size.y 
		"east":
			leap_frogger.position.x = leap_frogger.position.x + tile_map_size.x
		"west":
			leap_frogger.position.x = leap_frogger.position.x - tile_map_size.x
		"south":
			leap_frogger.position.y = leap_frogger.position.y + tile_map_size.y

func _on_north_body_entered(body):
	print("Heesoo entered north leaper")
	move_tiles("north")

func _on_east_body_entered(body):
	print("Heesoo entered east leaper")
	move_tiles("east")

func _on_west_body_entered(body):
	print("Heesoo entered west leaper")
	move_tiles("west")

func _on_south_body_entered(body):
	print("Heesoo entered south leaper")
	move_tiles("south")
