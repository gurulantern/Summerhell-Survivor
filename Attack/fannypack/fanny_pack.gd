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
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var scale_multiplier = Vector2(.5, .5)
var shrink_speed = .5

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
			damage = 5
			knockback_amount = 180
			attack_size = 1.0
			scale_multiplier = Vector2(0.8,0.8)
			
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

func enemy_hit(_charge):
	pass

func _on_timer_timeout():
	emit_signal("remove_from_array")
	queue_free()


func _on_collision_timer_timeout():
	collision.set_deferred("disabled", true)
