extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var is_critical = false
var scale_multiplier = Vector2(1.0, 1.0)

@export var snd_attack : AudioStreamWAV

var target
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 100
			damage = 10
			knockback_amount = 100
			scale_multiplier = scale_multiplier * (1 + player.spell_size)
		2:
			hp = 1
			speed = 100
			damage = 10
			knockback_amount = 100
			scale_multiplier = scale_multiplier * (1 + player.spell_size)
		3:
			hp = 2
			speed = 100
			damage = 10
			knockback_amount = 120
			scale_multiplier = scale_multiplier * (1 + player.spell_size)
		4:
			hp = 2
			speed = 100
			damage = 10
			knockback_amount = 120
			is_critical = true
			scale_multiplier = scale_multiplier * (1 + player.spell_size)
			
	self.set_scale(scale_multiplier)

func _physics_process(delta):
	position += angle*speed*delta
	

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("remove_from_array", self)
	queue_free()
