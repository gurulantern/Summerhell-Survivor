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

@export var chest_chance = .001
@export var anime_chance = .03
@export var food_chance = .05
@export var gold_chance = .1

var exp_pentagram = preload("res://Player/Objects/experience_pentagram.tscn")
var chest = preload("res://Player/Objects/chest.tscn")
var anime = preload("res://Player/Objects/anime_boy.tscn")
var food = preload("res://Player/Objects/food.tscn")
var gold = preload("res://Player/Objects/gold.tscn")

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

func _on_hurtbox_hurt(damage, angle, knockback_amount, is_critical):
	display_number(damage, damage_num_origin.position, is_critical)
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
	random_drop()

func spawn_drop(scn_preload):
	var new_drop = scn_preload.instantiate()
	new_drop.global_position = global_position
	loot_base.call_deferred("add_child", new_drop)

func random_drop():
	var random_value = randf()
	if random_value < chest_chance:
		spawn_drop(chest)
	elif random_value < anime_chance:
		spawn_drop(anime)
	elif random_value < food_chance:
		spawn_drop(food)
	elif random_value < gold_chance:
		spawn_drop(gold)

func display_number(value:int, position: Vector2, is_critical:bool):
	var number = damage_label.instantiate() as Label
	number.global_position = position
	number.text = str(value)
	
	var color: Color
	if is_critical:
		color = Color.CRIMSON
	else:
		color = Color.WHITE
	
	number.add_theme_color_override("font_color", color)
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
