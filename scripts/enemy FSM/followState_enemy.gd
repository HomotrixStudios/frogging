extends EnemyState

func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")


func update_physics(delta : float) -> void:
	if player == null:
		return
	var direction = Vector2(player.position.x - enemy.position.x,player.position.y - enemy.position.y)

	enemy.velocity.x = direction.x * enemy.x_speed * delta 
	enemy.velocity.y = direction.y * enemy.y_speed * delta

	if direction.length() >= (enemy.action_range) * 1.5:
		enemy.state_machine.change_state("MovingRandomState")
