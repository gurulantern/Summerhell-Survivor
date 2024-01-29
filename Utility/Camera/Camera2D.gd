extends Camera2D

@export_category("Follow Category")
@export var player : CharacterBody2D

@export_category("Camera Smoothing")
@export var smoothing_enabled : bool
@export_range(1,10) var smoothing_distance : int = 8
var camera_position: Vector2

@export_category("Shake")
var shake_amount : float = 0
var default_offset : Vector2 = offset
var pos_x : int
var pos_y : int
@onready var timer : Timer = $Timer
@onready var tween : Tween = create_tween()

var weight : float

func _ready():
	set_process(true)
	weight = float(11 - smoothing_distance) /100
	#randomize()

func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func _physics_process(delta):
	if player != null:
		
		if smoothing_enabled:
			# 11 is the max smoothing distance plus 1. 
			camera_position = lerp(global_position, player.global_position, weight)
		else:
			camera_position = player.global_position
			
		global_position = round(camera_position)


func _on_timer_timeout():
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, tween.TRANS_LINEAR, tween.EASE_IN)

func _on_heesoo_shake(time, amount):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()
