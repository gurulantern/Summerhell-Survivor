extends Area2D

@export var experience = 1

var target = null
var speed = -1

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var snd_collected = $snd_collected

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.play("blue")
	elif experience < 50:
		sprite.play("red")
	elif experience < 75:
		sprite.play("green")
	elif experience < 100:
		sprite.play("gold")
	elif experience < 200:
		sprite.play("black")

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	snd_collected.play()
	collision.set_deferred("disabled", true)
	sprite.visible = false
	return experience

func _on_snd_collected_finished():
	queue_free()
