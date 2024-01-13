extends EnemyBody

func _on_visible_on_screen_notifier_2d_screen_exited():
	anim.visible = false

func _on_visible_on_screen_notifier_2d_screen_entered():
	anim.visible = true
