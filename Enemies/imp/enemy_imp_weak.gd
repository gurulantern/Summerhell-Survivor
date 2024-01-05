extends CharacterBody2D

@export var enemy_name:String
@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var snd_hit = $snd_hit
@onready var snd_death = $snd_death
@onready var collision = $CollisionShape2D
@onready var hurtbox = $Hurtbox/CollisionShape2D


signal remove_from_array(object)

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	
	if velocity.x > 0:
		anim.flip_h = true
	elif velocity.x < 0:
		anim.flip_h = false
		
	velocity += knockback
	anim.play("move")
	move_and_slide()

func death():
	emit_signal("remove_from_array", self)
	collision.set_deferred("disabled", true)
	hurtbox.set_deferred("disabled", true)
	snd_death.play()
	var tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/progress", 1.0, 0.8).from(0.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	queue_free()

func _on_hurtbox_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()
