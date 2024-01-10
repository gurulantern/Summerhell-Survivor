extends Path2D

var speed = .20
var amount = 0
var attack_speed = 2

@onready var player = get_tree().get_first_node_in_group("player")
@onready var snd_attack : AudioStreamPlayer = $snd_attack
@onready var timer = get_node("Timer")

#GasLights
@onready var gasLight_node = get_node("GasLightPathFollow") 
@onready var gasLight2_node = get_node("GasLightPathFollow2")
@onready var gasLight3_node = get_node("GasLightPathFollow3")
@onready var gasLight4_node = get_node("GasLightPathFollow4")
@onready var gasLights : Array = [gasLight_node, gasLight2_node, gasLight3_node, gasLight4_node]

signal remove_from_array(object)

func _physics_process(delta):
	self.global_position = player.global_position
	for i in gasLights.size():
		gasLights[i].progress_ratio += delta * speed

# hopefully this turns it on
func activate():
	gasLights[amount-1].visible = true
	gasLights[amount-1].process_mode = Node.PROCESS_MODE_INHERIT

func play_attack():
	timer.start()
	snd_attack.play()
	for i in gasLights.size():
		gasLights[i].get_node("GasLight").get_node("AnimatedSprite2D").play("attack")
		gasLights[i].get_node("GasLight").get_node("CollisionShape2D").set_deferred("disabled", false)

func turn_off():
	for i in gasLights.size():
		gasLights[i].get_node("GasLight").get_node("AnimatedSprite2D").play("passive")
		gasLights[i].get_node("GasLight").get_node("CollisionShape2D").set_deferred("disabled", true)

func _on_timer_timeout():
	for i in gasLights.size():
		gasLights[i].get_node("GasLight").remove()
	turn_off()

func update_gasLight(current_level: int):
	if amount != current_level:
		amount = current_level
		activate()
	match current_level:
		1:
			speed = .20
			for i in gasLights.size():
				gasLights[i].get_node("GasLight").update(current_level)
		2:
			speed = .25
			for i in gasLights.size():
				gasLights[i].get_node("GasLight").update(current_level)
		3:
			speed = .25
			for i in gasLights.size():
				gasLights[i].get_node("GasLight").update(current_level)
		4:
			speed = .30
			for i in gasLights.size():
				gasLights[i].get_node("GasLight").update(current_level)
