class_name FlyEnemy extends Enemy

@onready var audio_player = $AudioStreamPlayer2D

func _physics_process(_delta: float) -> void:
	if direction == 1:
		muzzle.position = position + Vector2(19.0, 8.0)
	elif direction == -1:
		muzzle.position = position + Vector2(-19.0, 8.0)
	
	handle_animations()
	move_and_slide()


func _on_shootable_area_body_entered(body: Node2D) -> void:
	if body is Player:
		state_machine.change_state("AttackState")

func handle_animations() -> void:
	if not animation_player.is_playing():
		animation_player.play("idle")
	if direction == 1:
		sprite.flip_h = false
	elif direction == -1:
		sprite.flip_h = true