extends Area2D

@export var exp = 1

var target = null
var speed = -1

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var snd_collected = $snd_collected

func _ready():
	if exp < 5:
		return
	elif exp < 25:
		sprite.play("blue")
	elif exp < 50:
		sprite.play("red")
	elif exp < 75:
		sprite.play("green")
	elif exp < 100:
		sprite.play("gold")
	elif exp < 200:
		sprite.play("black")

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	snd_collected.play()
	collision.set_deferred("disabled", true)
	sprite.visible = false
	return exp

func _on_snd_collected_finished():
	queue_free()
