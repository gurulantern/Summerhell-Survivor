extends CharacterBody2D

@export var hp = 80
@export var maxhp = 80
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var modulate_origin = anim.modulate
@onready var berserk = false

#region Experience
var exp = 0
var exp_level = 1
var collected_exp = 0
var total_exp = 0
var collected_gold = 0
var total_gold = 0
#endregion

#region Attacks
var earPick = preload("res://Attack/earPick/ear_pick.tscn")
var fannyPack = preload("res://Attack/fannypack/fanny_pack.tscn")
var gasLight = preload("res://Attack/gaslight/gas_light_path.tscn")
@onready var hurtbox = get_node("Hurtbox")
@onready var bash = get_node("Bash")
#endregion

#region SFX
@onready var snd_anime_transform = preload("res://Audio/SFX/WAV/anime_transform.wav")
@onready var snd_anime_bash = preload("res://Audio/SFX/WAV/anime_bash.wav")
@onready var snd_victory = preload("res://Audio/UI/snd_victory.wav")
@onready var snd_lose = preload("res://Audio/UI/snd_lose.wav")
@onready var snd_levelUp = preload("res://Audio/UI/positive_trill.wav")
#endregion

#region Attack Nodes
@onready var earPickTimer = get_node("%EarPickTimer")
@onready var earPickAttackTimer = get_node("%EarPickAttackTimer")
@onready var fannyPackTimer = get_node("%FannyPackTimer")
@onready var fannyPackAttackTimer = get_node("%FannyPackAttackTimer")
@onready var gasLightTimer = get_node("%GasLightTimer")
@onready var gasLightAttackTimer = get_node("%GasLightAttackTimer")
@onready var gasLightPath = get_node("GasLightPath")
@onready var animeAttackTimer = get_node("%AnimeAttackTimer")
#endregion

#region Upgrade variables
var collected_upgrades_array = []
var upgrade_options_array = []
var armor = 0
var speed = 80
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0
#endregion

#region Ear pick Variables
var earPick_ammo = 0
var earPick_baseammo = 0
var earPick_attackspeed = 1.8
var earPick_level = 0
#endregion

#region Fanny pack Variables
var fannyPack_ammo = 0
var fannyPack_baseammo = 0
var fannyPack_attackspeed = 2
var fannyPack_level = 0
var flipped = false
#endregion

#region Gas light Variables
var gasLight_ammo = 0
var gasLight_baseammo = 0
var gasLight_attackspeed = 2
var gasLight_level = 0
#endregion

#region Anime Variables
var anime_ammo = 0
var anime_baseammo = 8
#endregion

#Enemy Related
var enemy_close = []

#region GUI Variables
#GUI
@onready var main_menu = preload("res://Scenes/TitleScreen/menu.tscn")
@onready var exp_bar = get_node("%ExperienceBar")
@onready var level_label = get_node("%LabelLevel")
@onready var level_panel = get_node("%LevelUp")
@onready var upgrade_options = get_node("%UpgradeOptions")
@onready var item_options = preload("res://Utility/UI/item_option.tscn")
@onready var health_bar = get_node("%HealthBar")
@onready var timer_label = get_node("%LabelTimer")
@onready var collected_weapons = get_node("%CollectedWeapons")
@onready var collected_upgrades = get_node("%CollectedUpgrades")
@onready var item_container = preload("res://Player/GUI/item_container.tscn")
@onready var death_panel = get_node("%DeathPanel")
@onready var exp_label = get_node("%ExpTotal")
@onready var gold_label = get_node("%GoldTotal")
@onready var result_label = get_node("%LabelResult")
@onready var pause_panel = get_node("%PausePanel")
var time = 0
var game_over = false
#endregion

signal player_death
signal shake(time, amount)

func _ready():
	upgrade_heesoo("earpick1")
	anim.play("idle")
	attack()
	set_exp_bar(exp, calculate_exp_cap())
	health_bar.max_value = maxhp
	health_bar.value = hp

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
		if berserk != true:
			anim.play("walk")
	else:
		if game_over != true && berserk != true:
			anim.play("idle")
	
	move_and_slide()
	
	time += delta
	change_time()

func attack():
	if earPick_level > 0:
		earPickTimer.wait_time = earPick_attackspeed * (1 - spell_cooldown)
		if earPickTimer.is_stopped():
			earPickTimer.start()
	if fannyPack_level > 0:
		fannyPackTimer.wait_time = fannyPack_attackspeed * (1 - spell_cooldown)
		if fannyPackTimer.is_stopped():
			fannyPackTimer.start()
	if gasLight_level > 0:
		gasLightTimer.wait_time = gasLight_attackspeed * (1 - spell_cooldown)
		if gasLightTimer.is_stopped():
			gasLightTimer.start()

#region Hurtbox and Death
func hurt_tint():
	print("Hurt tint called")
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.CRIMSON, .1)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self, "modulate", modulate_origin, .1)

func _on_hurtbox_hurt(damage, _angle, _knockback, _is_critical):
	hurt_tint()
	hp -= clamp(damage-armor, 1.0, 999.0)
	health_bar.max_value = maxhp
	health_bar.value = hp
	if hp <= 0:
		game_over = true
		speed = 0
		anim.play("die")
		await anim.animation_finished
		death()

func death():
	death_panel.visible = true
	exp_label.text = str(total_exp)
	calculate_gold()
	gold_label.text = str(total_gold)
	Save.SAVE_DICT["gold"] += total_gold
	emit_signal("player_death")
	get_tree().paused = true
	var tween = death_panel.create_tween()
	tween.tween_property(
		death_panel, "position", Vector2(220,50), 3.0
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 300:
		Save.SAVE_DICT["wins"] += 1
		result_label.text = "You survived!"
		SoundManager.play_music(snd_victory)
	else:
		Save.SAVE_DICT["losses"] += 1
		result_label.text = "You died!"
		SoundManager.play_music_at_volume(snd_lose, -20.0)

func _on_menu_button_click_end():
	print("Saving and leaving")
	SaverLoader.save_game()
	get_tree().paused = false
	SoundManager.stop_music()
	SceneSwitcher.switch_scene("res://Scenes/TitleScreen/menu.tscn")

#endregion

#region Ear Pick
#Ear Pick Timers 
#Loads ammunition
func _on_ear_pick_timer_timeout():
	earPick_ammo += earPick_baseammo + additional_attacks
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

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP
#endregion

#region Fanny Pack
#Fanny Pack timers
func _on_fanny_pack_timer_timeout():
	fannyPack_ammo += fannyPack_baseammo + additional_attacks
	fannyPackAttackTimer.start()

func _on_fanny_pack_attack_timer_timeout():
	if fannyPack_ammo > 0:
		var fannyPack_attack = fannyPack.instantiate()
		var texture_size = fannyPack_attack.get_node("Sprite2D").texture.get_size()
		fannyPack_attack.level = fannyPack_level
		if flipped:
			SoundManager.play_sound(fannyPack_attack.snd_attack1)
			fannyPack_attack.flip_sprite()
			fannyPack_attack.position = get_spawn_point(global_position, texture_size, fannyPack_attack.scale_multiplier)
		else:
			SoundManager.play_sound(fannyPack_attack.snd_attack2)
			fannyPack_attack.position = get_spawn_point(global_position, -texture_size, fannyPack_attack.scale_multiplier)
		add_child(fannyPack_attack)
		fannyPack_ammo -= 1
		if fannyPack_ammo > 0:
			flipped = !flipped
			fannyPackAttackTimer.start()
		else:
			flipped = !flipped
			fannyPackAttackTimer.stop()

func get_spawn_point(parent_global_position: Vector2, attack_size: Vector2, attack_scale: Vector2) -> Vector2:
	# Calculate the offset to position the weapon's bottom right corner at the center of the parent
	var offset = Vector2(attack_size.x * 1.0 * attack_scale.x, attack_size.y * 0.5 * attack_scale.y)
	# Calculate the spawn position by adding the offset to the parent's global position
	var spawn_position = parent_global_position + offset
	
	return spawn_position
#endregion

#region Gas Light
func _on_gas_light_timer_timeout():
	gasLight_ammo += gasLight_baseammo + additional_attacks
	gasLightAttackTimer.start()

func _on_gas_light_attack_timer_timeout():
	if gasLight_ammo > 0:
		gasLight_ammo -= 1
		gasLightPath.play_attack()
		gasLightAttackTimer.start()
	else:
		gasLightAttackTimer.stop()
#endregion

#region Grab/Collect
func _on_grab_area_area_entered(area):
	if area.is_in_group("pentagram"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("pentagram"):
		var pentagram_exp = area.collect()
		calculate_exp(pentagram_exp)
	elif area.is_in_group("gold"):
		var gold_pickup = area.collect()
		collected_gold += gold_pickup
	elif area.is_in_group("anime"):
		area.collect()
		anime_transform()
	elif area.is_in_group("chest"):
		area.collect()
		open_chest()
	elif area.is_in_group("food"):
		area.collect()
		hp += 20
		hp = clamp(hp, 0, maxhp)
#endregion

#region Enemy Detection
func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body) && not body.is_in_group("player") :
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
#endregion

#region Leveling Up
func calculate_exp(pentagram_exp):
	var exp_required = calculate_exp_cap()
	collected_exp += pentagram_exp
	total_exp += pentagram_exp
	print(collected_exp)
	if exp + collected_exp >= exp_required:
		collected_exp -= exp_required-exp
		exp_level += 1
		exp = 0
		exp_required = calculate_exp_cap()
		level_up()
	else:
		exp += collected_exp
		collected_exp = 0
	
	set_exp_bar(exp, exp_required)

func calculate_exp_cap():
	var exp_cap = exp_level
	if exp_level < 20:
		exp_cap = exp_level * 5
	elif exp_level < 40:
		exp_cap = 95 * (exp_level-19)*8
	else:
		exp_cap = 255 + (exp_level-39)*12
	return exp_cap

func set_exp_bar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value

func level_up():
	SoundManager.play_ui_sound(snd_levelUp)
	var tween = level_panel.create_tween()
	tween.tween_property(
		level_panel, "position:y", 50, 0.2
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	level_panel.visible = true
	var options = 0
	var options_max = 3
	while options < options_max:
		var option_choice = item_options.instantiate()
		option_choice.item = get_random_item()
		upgrade_options.add_child(option_choice)
		options += 1
	get_tree().paused = true
	level_label.text = str("Lvl ", exp_level)

func upgrade_heesoo(upgrade):
	match upgrade:
		"earpick1":
			earPick_level = 1
			earPick_baseammo += 1
		"earpick2":
			earPick_level = 2
			earPick_baseammo += 1
		"earpick3":
			earPick_level = 3
		"earpick4":
			earPick_level = 4
			earPick_baseammo += 2
		"fannypack1":
			fannyPack_level = 1
			fannyPack_baseammo = 1
		"fannypack2":
			fannyPack_level = 2
			fannyPack_attackspeed -= 0.5
		"fannypack3":
			fannyPack_level = 3
			fannyPack_baseammo += 1
		"fannypack4":
			fannyPack_level = 4
			fannyPack_baseammo += 1
			fannyPack_attackspeed -= 0.5
		"gaslight1":
			gasLightPath.process_mode = Node.PROCESS_MODE_INHERIT
			gasLightPath.visible = true
			gasLight_level += 1
			gasLight_baseammo += 1
		"gaslight2", "gaslight3", "gaslight4":
			gasLight_level += 1
			gasLight_baseammo +=1
		"clothes1", "clothes2", "clothes3", "clothes4":
			armor += 1
		"coffee1", "coffee2", "coffee3", "coffee4":
			speed += 20 
		"book1", "book2", "book3", "book4":
			spell_size += 0.10
		"podcast1", "podcast2", "podcast3", "podcast4":
			spell_cooldown += 0.05
		"glasses1", "glasses2":
			additional_attacks += 1
		"sashimi":
			hp += 20
			hp = clamp(hp, 0, maxhp)
	
	gasLightPath.update_gasLight(gasLight_level)
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgrade_options.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options_array.clear()
	print(upgrade)
	collected_upgrades_array.append(upgrade)
	level_panel.visible = false
	level_panel.position = Vector2(220, 400)
	get_tree().paused = false
	calculate_exp(0) #Recursive call for remainder exp

func calculate_gold():
	var gold_from_exp = total_exp/4
	total_gold = gold_from_exp + collected_gold

func get_random_item():
	var db_list = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades_array: 
			pass
		elif i in upgrade_options_array:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0:
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades_array:
					to_add = false
				else: 
					db_list.append(i)
			if to_add:
				db_list.append(i) 
		else:
			db_list.append(i)
	if db_list.size() > 0:
		var random_item = db_list.pick_random()
		upgrade_options_array.append(random_item)
		return random_item
	else:
		return null
#endregion

func change_time():
	var pass_time = int(time)
	var get_m = int(pass_time/60)
	var get_s = pass_time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	timer_label.text = str(get_m, ":", get_s)

func adjust_gui_collection(upgrade):
	var get_upgraded_name = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_items = []
		for i in collected_upgrades_array:
			get_collected_items.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_name in get_collected_items:
			var new_item = item_container.instantiate()
			new_item.upgrade = upgrade
			new_item.upgrade_type = get_upgraded_name
			match get_type:
				"weapon":
					print("Selected upgrade: ", upgrade)
					collected_weapons.add_child(new_item)
				"upgrade":
					print("Selected upgrade: ", upgrade)
					collected_upgrades.add_child(new_item)
		else:
			match get_type:
				"weapon":
					var collection = collected_weapons.get_children()
					for n in collection:
						if n.upgrade_type == get_upgraded_name:
							n.update_upgrade(upgrade)
				"upgrade":
					var collection = collected_upgrades.get_children()
					for n in collection:
						if n.upgrade_type == get_upgraded_name:
							n.update_upgrade(upgrade)

#region Pause Menu
func open_pause_menu():
	if game_over == false:
		get_tree().paused = true
		var tween = pause_panel.create_tween()
		tween.tween_property(
			pause_panel, "position", Vector2(130,60), 1.0
			).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.play()

func close_pause_menu():
	get_tree().paused = false
	var tween = pause_panel.create_tween()
	tween.tween_property(
		pause_panel, "position", Vector2(-450,250), 1.0
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	await tween.finished

func _on_pause_panel_pause_game():
	open_pause_menu()

func _on_pause_panel_unpause_game():
	close_pause_menu()
#endregion

#region Loot Functions
func anime_transform():
	if berserk:
		anime_ammo += anime_baseammo
	else:
		berserk = true
		hurtbox.process_mode = Node.PROCESS_MODE_DISABLED
		speed = 0
		anim.play("anime_transform")
		var streamer = SoundManager.play_sound(snd_anime_transform)
		streamer.volume_db = 5.0
		await anim.animation_finished
		anime_bash()
		anime_ammo += anime_baseammo
		animeAttackTimer.start()
		speed = 80
	
	
func anime_bash():
	var tween = anim.create_tween()
	tween.tween_property(
		anim, "offset:y", -10,.05).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	#tween.play()
	await tween.finished
	tween = create_tween()
	tween.tween_property(
		anim, "offset:y", 0, .05).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	
	if anime_ammo % 2 == 1:
		anim.play("anime_smash1")
	else:
		anim.play("anime_smash2")
	
	SoundManager.play_sound(snd_anime_bash)
	emit_signal("shake", 0.2, 3)
	bash.attack()

func _on_anime_timer_timeout():
	hurtbox.process_mode = Node.PROCESS_MODE_INHERIT
	berserk = false

func _on_anime_attack_timer_timeout():
	if anime_ammo > 0:
		anime_bash()
		anime_ammo -= 1
		if anime_ammo > 0:
			animeAttackTimer.start()
		else:
			animeAttackTimer.stop()
			hurtbox.process_mode = Node.PROCESS_MODE_INHERIT
			berserk = false

func open_chest():
	pass
#endregion

func _on_dog_timer_timeout():
	pass # Replace with function body.

func _on_dog_attack_timer_timeout():
	pass # Replace with function body.
