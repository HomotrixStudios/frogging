extends EnemyState

var target_pos : Vector2
@onready var timer = $Timer

func enter() -> void:
	target_pos = enemy.global_position + Vector2(randf_range(-enemy.x_movement, enemy.x_movement), randf_range(-enemy.y_movement, enemy.y_movement))

func update_physics(delta : float) -> void:
	var direction := Vector2(target_pos.x - enemy.global_position.x, target_pos.y - enemy.global_position.y)

	enemy.velocity.x = (direction.x * enemy.speed) * delta
	enemy.velocity.y = (direction.y * enemy.speed) * delta

	if target_pos.distance_to(enemy.global_position) <= 0.1:
		enemy.state_machine.change_state("IdleState")
	
	if enemy.is_player_near():
		enemy.state_machine.change_state("FollowState")
	
	handle_animations(direction.x)
	
func handle_animations(facing_direction : float):
	enemy.animation_player.play("follow")
	if facing_direction >= 0:
		enemy.sprite.flip_h = false
	else:
		enemy.sprite.flip_h = true

func _on_timer_timeout() -> void:
	enemy.state_machine.change_state("IdleState")
