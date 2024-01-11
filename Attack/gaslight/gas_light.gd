extends Area2D

var level = 1
var hp = 9999
var damage = 4
var knockback_amount = 120
var scale_multiplier: Vector2 = Vector2(1.0, 1.0)

@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

func _ready():
	match level:
		1:
			hp = 1
			damage = 4
			knockback_amount = 120
			scale_multiplier = Vector2(1.0, 1.0)

func update(current_level: int):
	var size
	if level != current_level:
		level = current_level
	match current_level:
		1:
			hp = 1
			damage = 5
			knockback_amount = 120
		2:
			hp = 1
			damage = 5
			knockback_amount = 120
		3:
			hp = 1
			damage = 5
			knockback_amount = 130
		4:
			hp = 1
			damage = 8
			knockback_amount = 135
	size = scale_multiplier * (1 + player.spell_size)
	self.set_scale(scale_multiplier)

func remove():
	emit_signal("remove_from_array", self)

func enemy_hit(charge = 1):
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()
