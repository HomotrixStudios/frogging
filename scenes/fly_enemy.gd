extends CharacterBody2D
class_name FlyEnemy
	
@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):
	handle_animations()
	move_and_slide()

func handle_animations() -> void:
	if velocity.x > 0:
		sprite.play("flying_dx")
	elif velocity.x < 0:
		sprite.play("flying_sx")
