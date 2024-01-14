extends CharacterBody2D

class_name EnemyBody

@export var enemy_name:String
@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var exp = 5
@export var enemy_damage = 1
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var damage_label = preload("res://Enemies/damage_number.tscn")
@onready var damage_num_origin = $EnemyBase/DamageNumOrigin
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var snd_hit = $EnemyBase/snd_hit
@onready var snd_death = $EnemyBase/snd_death
@onready var collision = $CollisionShape2D
@onready var hurtbox = $EnemyBase/Hurtbox
@onready var hurtbox_collision = $EnemyBase/Hurtbox/CollisionShape2D
@onready var hitbox = $EnemyBase/Hitbox

var exp_pentagram = preload("res://Player/Objects/experience_pentagram.tscn")
signal remove_from_array(object)

func _ready():
	hitbox.damage = enemy_damage
	hurtbox.connect("hurt",Callable(self, "_on_hurt_box_hurt"))

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
	Save.SAVE_DICT[enemy_name] += 1
	collision.set_deferred("disabled", true)
	hurtbox_collision.set_deferred("disabled", true)
	snd_death.play()
	var tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/progress", 1.0, 0.8).from(0.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	queue_free()

func _on_hurtbox_hurt(damage, angle, knockback_amount):
	display_number(damage, damage_num_origin.position, false)
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()

func _on_snd_death_finished():
	var new_pentagram = exp_pentagram.instantiate()
	new_pentagram.global_position = global_position
	new_pentagram.exp = exp
	loot_base.call_deferred("add_child", new_pentagram)

func display_number(value:int, position: Vector2, is_critical:bool = false):
	var number = damage_label.instantiate()
	number.global_position = position
	number.text = str(value)
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size/2)
	var tween = number.create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y -24, 0.2
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.2)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.2
	).set_ease(Tween.EASE_IN).set_delay(0.2)
	
	await tween.finished
	number.queue_free()
