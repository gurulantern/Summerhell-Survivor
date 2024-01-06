extends Area2D

var level = 1
var hp = 9999
var speed = .1
var damage = 5
var knockback_amount = 120
var attack_size = 1.0

signal remove_from_array(object)

func _ready():
	match level:
		1:
			hp = 1
			speed = .1
			damage = 5
			knockback_amount = 120
			attack_size = 1.0

func remove():
	emit_signal("remove_from_array", self)

func enemy_hit(charge = 1):
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()
