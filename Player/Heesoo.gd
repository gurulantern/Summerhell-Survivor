extends CharacterBody2D

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@export var hp = 80
const speed = 80

#Experience
var exp = 0
var exp_level = 1
var collected_exp = 0

#Attacks
var earPick = preload("res://Attack/earPick/ear_pick.tscn")
var fannyPack = preload("res://Attack/fannypack/fanny_pack.tscn")
var gasLight = preload("res://Attack/gaslight/gas_light_path.tscn")

#AttackNodes
@onready var earPickTimer = get_node("%EarPickTimer")
@onready var earPickAttackTimer = get_node("%EarPickAttackTimer")
@onready var fannyPackTimer = get_node("%FannyPackTimer")
@onready var fannyPackAttackTimer = get_node("%FannyPackAttackTimer")
@onready var gasLightTimer = get_node("%GasLightTimer")
@onready var gasLightAttackTimer = get_node("%GasLightAttackTimer")
@onready var gasLightPath = get_node("GasLightPath")

#Ear Pick
var earPick_ammo = 0
var earPick_baseammo = 1
var earPick_attackspeed = 1.8
var earPick_level = 1

#Fanny Pack
var fannyPack_ammo = 0
var fannyPack_baseammo = 2
var fannyPack_attackspeed = 2
var fannyPack_level = 1
var flipped = false

#Gas Light
var gasLight_ammo = 0
var gasLight_baseammo = 2
var gasLight_attackspeed = 2
var gasLight_level = 1

#Enemy Related
var enemy_close = []

func _ready():
	anim.play("idle")
	attack()

func _physics_process(delta):
	var direction : Vector2 = Input.get_vector("left", "right", "up", "down").normalized()

	if direction: 
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	if velocity.x > 0:
		anim.flip_h = true
	elif velocity.x < 0:
		anim.flip_h = false
		
	if velocity.y != 0 or velocity.x != 0:
		anim.play("walk")	
	else:
		anim.play("idle")
	
	move_and_slide()

func attack():
	if earPick_level > 0:
		earPickTimer.wait_time = earPick_attackspeed
		if earPickTimer.is_stopped():
			earPickTimer.start()
	if fannyPack_level > 0:
		fannyPackTimer.wait_time = fannyPack_attackspeed
		if fannyPackTimer.is_stopped():
			fannyPackTimer.start()
	if gasLight_level > 0:
		gasLightTimer.wait_time = gasLight_attackspeed
		if gasLightTimer.is_stopped():
			print("Gaslight timer starting...")
			gasLightTimer.start()

func _on_hurtbox_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)

#Ear Pick Timers 
#Loads ammunition
func _on_ear_pick_timer_timeout():
	earPick_ammo += earPick_baseammo
	earPickAttackTimer.start()

#Shoots
func _on_ear_pick_attack_timer_timeout():
	if earPick_ammo > 0:
		var earPick_attack = earPick.instantiate()
		earPick_attack.position = global_position
		earPick_attack.target = get_random_target()
		earPick_attack.level = earPick_level
		add_child(earPick_attack)
		earPick_ammo -= 1
		if earPick_ammo > 0:
			earPickAttackTimer.start()
		else:
			earPickAttackTimer.stop()

#Fanny Pack timers
func _on_fanny_pack_timer_timeout():
	fannyPack_ammo += fannyPack_baseammo
	fannyPackAttackTimer.start()

func _on_fanny_pack_attack_timer_timeout():
	if fannyPack_ammo > 0:
		var fannyPack_attack = fannyPack.instantiate()
		var texture_size = fannyPack_attack.get_node("Sprite2D").texture.get_size()
		fannyPack_attack.level = fannyPack_level
		if flipped:
			fannyPack_attack.flip_sprite()
			fannyPack_attack.position = get_spawn_point(global_position, texture_size, fannyPack_attack.scale_multiplier)
		else:
			fannyPack_attack.position = get_spawn_point(global_position, -texture_size, fannyPack_attack.scale_multiplier)
		add_child(fannyPack_attack)
		fannyPack_ammo -= 1
		if fannyPack_ammo > 0:
			flipped = !flipped
			fannyPackAttackTimer.start()
		else:
			flipped = !flipped
			fannyPackAttackTimer.stop()

func _on_gas_light_timer_timeout():
	gasLight_ammo += gasLight_baseammo
	gasLightAttackTimer.start()

func _on_gas_light_attack_timer_timeout():
	print("GaslightAttackTimer timedout...")
	gasLightPath.play_attack()
	gasLight_ammo -= 1
	if gasLight_ammo > 0:
		gasLightAttackTimer.start()
	else:
		gasLightAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func get_spawn_point(parent_global_position: Vector2, attack_size: Vector2, attack_scale: Vector2) -> Vector2:
	# Calculate the offset to position the weapon's bottom right corner at the center of the parent
	var offset = Vector2(attack_size.x * 1.0 * attack_scale.x, attack_size.y * 0.5 * attack_scale.y)
	# Calculate the spawn position by adding the offset to the parent's global position
	var spawn_position = parent_global_position + offset
	
	return spawn_position


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		print("got loot")
		var pentagram_exp = area.collect()
		print(pentagram_exp)
		calculate_exp(pentagram_exp)

func calculate_exp(pentagram_exp):
	var exp_required = calculate_exp_cap()
	collected_exp += pentagram_exp
	print(collected_exp)
	if exp + collected_exp >= exp_required:
		collected_exp -= exp_required-exp
		exp_level += 1
		print("Level:", exp_level)
		exp = 0
		exp_required = calculate_exp_cap()
	else:
		exp += collected_exp
		collected_exp = 0

func calculate_exp_cap():
	var exp_cap = exp_level
	if exp_level < 20:
		exp_cap = exp_level * 5
	elif exp_level < 40:
		exp_cap + 95 * (exp_level-19)*8
	else:
		exp_cap = 255 + (exp_level-39)*12
	return exp_cap
