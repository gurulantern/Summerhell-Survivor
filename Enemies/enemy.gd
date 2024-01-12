extends EnemyBody

func _on_visible_on_screen_notifier_2d_screen_exited():
	anim.visible = false
	print(self, " is off screen : ", anim.visible)

func _on_visible_on_screen_notifier_2d_screen_entered():
	anim.visible = true
	print(self, " is on screen : ", anim.visible)

