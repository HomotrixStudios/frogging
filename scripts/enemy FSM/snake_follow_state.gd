extends EnemyState

@onready var follow_timer = $FollowTimer
var direction : Vector2

var original_speed : float

func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")
	original_speed = enemy.speed
	enemy.speed += 20


func update_physics(_delta : float) -> void:

	direction = enemy.global_position.direction_to(player.global_position).normalized()

	if not enemy.is_player_in_area:
		if follow_timer.is_stopped():
			follow_timer.start()
	else:
		follow_timer.stop()

	if enemy.is_on_wall():
		print("gotta change")
		enemy.state_machine.change_state("MovingRandomState")

	if direction.x > 0:
		enemy.pivot.scale.x = 1
	elif direction.x < 0:
		enemy.pivot.scale.x = -1

	enemy.velocity.x = direction.x * enemy.speed

func exit() -> void:
	enemy.speed = original_speed


func _on_follow_timer_timeout() -> void:
	enemy.velocity = Vector2.ZERO
	enemy.state_machine.change_state("MovingRandomState")
	
