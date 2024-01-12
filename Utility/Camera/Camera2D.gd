extends Camera2D

@export_category("Follow Category")
@export var player : CharacterBody2D

@export_category("Camera Smoothing")
@export var smoothing_enabled : bool
@export_range(1,10) var smoothing_distance : int = 8

var weight : float

func _ready():
	weight = float(11 - smoothing_distance) /100

func _physics_process(delta):
	
	if player != null:
		var camera_position : Vector2
		
		if smoothing_enabled:
			# 11 is the max smoothing distance plus 1. 
			camera_position = lerp(global_position, player.global_position, weight)
		else:
			camera_position = player.global_position
			
		global_position = camera_position.floor()
