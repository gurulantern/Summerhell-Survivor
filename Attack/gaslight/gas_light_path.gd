extends Path2D

var speed = .1
var amount = 1
var radius : float = 10.0
var velocity = Vector2.ZERO

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
	print("Gaslight timer timedout...")
	for i in gasLights.size():
		gasLights[i].get_node("GasLight").remove()
	turn_off()
