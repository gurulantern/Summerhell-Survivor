extends Area2D

#NOTES ON ADJUSTMENTS
# To change duration of attack change the timer node
# To change the shrink time in direction to Heesoo change the shrink_speed
# To change the scaling change the tween function

const move_speed = 100
var velocity = Vector2.ZERO

var level = 1
var hp = 9999 #So it won't despawn after hitting other enemies
var speed = 100.0
var damage = 7
var knockback_amount = 100
var is_critical = false
var scale_multiplier = Vector2(.5, .5)
var shrink_speed = .5

@export var snd_attack1 : AudioStreamWAV
@export var snd_attack2 : AudioStreamWAV

signal remove_from_array(object) #Needed for the hurtbox

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite_size : Vector2 = $Sprite2D.get_rect().size
@onready var timer = $Timer
@onready var collision = $CollisionShape2D

func _ready():
	match level:
		1:
			hp = 9999
			speed = 100.0
			damage = 10
			knockback_amount = 180
			scale_multiplier = scale_multiplier * (1 + player.spell_size)
		2:
			hp = 9999
			speed = 100.0
			damage = 12
			knockback_amount = 190
			scale_multiplier = scale_multiplier * (1 + player.spell_size)
		3:
			hp = 9999
			speed = 100.0
			damage = 14
			knockback_amount = 200
			scale_multiplier = scale_multiplier * (1 + player.spell_size)
		4:
			hp = 9999
			speed = 100.0
			damage = 16
			knockback_amount = 210
			is_critical = true
			scale_multiplier = scale_multiplier * (1 + player.spell_size)
			
	self.set_scale(scale_multiplier)
	timer.start()
	shrink()

func _physics_process(delta):
	velocity = player.get_real_velocity()
	var target_direction = (player.global_position - self.position).normalized()
	self.translate(velocity * delta)
	self.translate(shrink_speed * target_direction)


func flip_sprite():
	$Sprite2D.flip_h = true
	$Sprite2D.flip_v = true

func shrink():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale:x", 0.6, 0.6).from(scale_multiplier.x).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale:y", 0.6, 0.6).from(scale_multiplier.y).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()

func _on_collision_timer_timeout():
	collision.set_deferred("disabled", true)
