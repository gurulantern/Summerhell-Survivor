extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage, angle, knockback, is_critical)

var hit_once_array = []

func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: #HitOnce
					if hit_once_array.has(area) == false:
						hit_once_array.append(area)
						if area.has_signal("remove_from_array"):
							if not area.is_connected("remove_from_array", Callable(self,"remove_from_list")):
								area.connect("remove_from_array", Callable(self,"remove_from_list"))
					else:
						return
				2: #DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			var is_critical = false
			if not area.get("angle") == null:
				angle = area.angle
			else:
				angle = player.global_position.direction_to(self.global_position)
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			if not area.get("is_critical") == null:
				is_critical = area.is_critical 
			emit_signal("hurt", damage, angle, knockback, is_critical)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)

func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
