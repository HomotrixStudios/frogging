class_name FlyEnemy extends Enemy


func _physics_process(_delta: float) -> void:
	if direction == 1:
		muzzle.position = position + Vector2(19.0, 8.0)
	elif direction == -1:
		muzzle.position = position + Vector2(-19.0, 8.0)

	move_and_slide()


func _on_shootable_area_body_entered(body: Node2D) -> void:
	if body is Player:
		state_machine.change_state("AttackState")
