extends Path2D

var level = 1
var hp = 9999
var speed = 100
var damage = 5
var knockback_amount = 120
var attack_size = 1.0
var amount = 1
var radius : float = 10.0
var velocity = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var snd_attack : AudioStreamPlayer = $snd_attack

#GasLights
@onready var gasLight_node = get_node("GasLightPathFollow") 
@onready var gasLight2_node = get_node("GasLightPathFollow2")
@onready var gasLight3_node = get_node("GasLightPathFollow3")
@onready var gasLight4_node = get_node("GasLightPathFollow4")
@onready var gasLights : Array = [gasLight_node, gasLight2_node, gasLight3_node, gasLight4_node]
signal remove_from_array(object)

func _ready():
	match level:
		1:
			hp = 1
			speed = .1
			damage = 5
			knockback_amount = 120
			attack_size = 1.0


func _physics_process(delta):
	self.global_position = player.global_position
	for i in gasLights.size():
		gasLights[i].progress_ratio += delta * speed

func play_attack():
	snd_attack.play()
	

func enemy_hit(charge = 1):
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()

func _on_gas_light_timer_timeout():
	pass

func _on_gas_light_attack_timer_timeout():
	play_attack()
	pass
