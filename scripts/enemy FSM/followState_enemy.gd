extends EnemyState

func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")


func update_physics(delta : float) -> void:
	if player == null:
		return
	var direction = Vector2(player.position.x - enemy.position.x, player.position.y - enemy.position.y)

	enemy.velocity.x = direction.x * enemy.speed * delta
	enemy.velocity.y = direction.y * enemy.speed * delta

	handle_animations(direction.x)

	if direction.length() >= (enemy.action_range) * 1.5:
		enemy.state_machine.change_state("IdleState")


func handle_animations(direction : float) -> void:
	enemy.animation_player.play("follow")
	if direction >= 0:
		enemy.sprite.flip_h = false
	if direction < 0:
		enemy.sprite.flip_h = true
	
