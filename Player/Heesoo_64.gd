extends CharacterBody2D


@export var speed = 90
@onready var anim = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var sensor = $Sensor

@onready var pause_panel = get_node("%PausePanel")

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
		anim.play("walking")
	else:
		anim.play("idle")
	
	move_and_slide()

func open_pause_menu():
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

func _on_menu_button_click_end():
	print("Saving and leaving")
	SaverLoader.save_game()
	get_tree().paused = false
	#SoundManager.stop_music()
	SceneSwitcher.switch_scene("res://Scenes/main.tscn")
	print("Okay")

func _on_large_tart_exit_area_entered(area):
	pass # Replace with function body.


func _on_large_tart_exit_area_exited(area):
	pass # Replace with function body.


func _on_lil_softie_exit_area_entered(area):
	pass # Replace with function body.


func _on_lil_softie_exit_area_exited(area):
	pass # Replace with function body.
