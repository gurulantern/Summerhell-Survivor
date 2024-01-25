extends CharacterBody2D


const speed = 80
@onready var anim = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var sensor = $Sensor

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
