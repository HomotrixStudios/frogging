extends EnemyState

var target_pos : Vector2
##The maximum time the enemy can use to reach random position
@onready var timer : Timer = $RandomPosTimer
var direction : Vector2
var is_waiting : bool = true
var going_to_b : bool = true

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	is_waiting = true
	
	timer.stop() #to make sure the timer won't be running
	
	#Time in which fly will be standing
	await get_tree().create_timer(randf_range(1.0,2.5)).timeout 
	
	#If it died or changed state it would be useless to go further
	if enemy.state_machine.current_state.name != "MovingRandomState":
		return

	is_waiting = false #No more waiting, can go towards the target position

	if timer.is_stopped():
		timer.start()

	#Picking one of the two markers position
	if going_to_b:
		target_pos = enemy.pos_b
	else:
		target_pos = enemy.pos_a

	going_to_b = not going_to_b

func update_physics(_delta : float) -> void:
	#If player is close and we can see him, then we can follow him
	if enemy.is_player_in_area and enemy.can_see_player:
		enemy.state_machine.change_state("FollowState")
		return
	
	if is_waiting:
		return 

	direction = enemy.global_position.direction_to(target_pos)
	
	if enemy.has_node("Pivot"):
		if direction.x > 0:
			enemy.pivot.scale.x = 1
		elif direction.x < 0:
			enemy.pivot.scale.x = -1


	#If we catch a wall or we reached the point, we can restart the state
	if enemy.is_on_wall() or enemy.global_position.distance_to(target_pos) <= 3:
		enemy.velocity = Vector2.ZERO
		enemy.state_machine.change_state("MovingRandomState")
		return

	#I don't think I need to explain this
	enemy.velocity = direction * enemy.speed
	

func _on_timer_timeout() -> void:
	#If nothing strange happened, we can restart the state 
	if enemy.state_machine.current_state.name == "MovingRandomState":
		enemy.state_machine.change_state("MovingRandomState")
