extends Area2D

var damage = 20
var knockback_amount = 180
var is_critical = true
@onready var collision = $CollisionShape2D
@onready var timer = $CollisionTimer

func _ready():
	collision.set_deferred("disabled", true)

func attack():
	collision.set_deferred("disabled", false)
	timer.start()

func _on_collision_timer_timeout():
	collision.set_deferred("disabled", true)
