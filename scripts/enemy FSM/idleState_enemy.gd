extends EnemyState

@export_range(1.0, 10.0) var idle_timer : float = 5.0

func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")
	enemy.animation_player.play("idle")
	enemy.velocity = Vector2.ZERO
	idle_timer = 5.0
	

func update(delta : float) -> void:
	if player == null:
		return

	idle_timer -= delta
	if idle_timer <= 0:
		enemy.state_machine.change_state("MovingRandomState")

	if enemy.is_player_near():
		enemy.state_machine.change_state("FollowState")
