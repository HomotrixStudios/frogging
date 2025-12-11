extends State
class_name EnemyFollow


func enter():
	player = get_tree().get_first_node_in_group("Player")

func update_physics(_delta : float):
	var direction = player.global_position - enemy.global_position

	if direction.length() > 25:
		enemy.velocity = direction.normalized() * speed
	else:
		enemy.velocity = Vector2.ZERO

	if direction.length() > action_range:
		transitioned.emit(self, "idle")
