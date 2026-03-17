extends EnemyState

@onready var follow_timer = $FollowTimer
var direction : Vector2


func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")


func update_physics(_delta : float) -> void:

	direction = enemy.global_position.direction_to(player.global_position).normalized()

	if not enemy.can_see_player:
		if follow_timer.is_stopped():
			follow_timer.start()

	enemy.velocity = direction * enemy.speed


func _on_follow_timer_timeout() -> void:
	enemy.velocity = Vector2.ZERO
