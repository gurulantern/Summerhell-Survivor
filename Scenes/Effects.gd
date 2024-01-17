extends CanvasLayer

@onready var quake = $Quake

func set_quake_size(value: float):
	quake.material.set_shader_parameter("size", value)

func set_quake_thickness(value: float):
	quake.material.set_shader_parameter("thickness", value)

func _on_heesoo_quake(start_value: float, end_value: float, duration: float):
	quake.visible = true
	var tween = create_tween()
	tween.tween_method(set_quake_size, start_value, end_value, duration)
	tween.play()
	await tween.finished
	quake.visible = false

