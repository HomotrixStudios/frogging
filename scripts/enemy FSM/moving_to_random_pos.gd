extends EnemyState

var target_pos : Vector2
##The maximum time the enemy can use to reach random position
@onready var timer : Timer = $RandomPosTimer

func enter() -> void:
	timer.start()
	target_pos = enemy.global_position + Vector2(randf_range(-enemy.x_speed, enemy.x_speed), randf_range(-enemy.y_speed, enemy.y_speed))

func update_physics(delta : float) -> void:
	var direction := Vector2(target_pos.x - enemy.global_position.x, target_pos.y - enemy.global_position.y)
 
	enemy.velocity.x = (direction.x * enemy.x_speed) * delta
	enemy.velocity.y = (direction.y * enemy.y_speed) * delta
	
	if enemy.state_machine.find_child("FollowState"):
		if enemy.is_player_near():
			enemy.state_machine.change_state("FollowState")

func _on_timer_timeout() -> void:
	enemy.state_machine.change_state("MovingRandomState")
