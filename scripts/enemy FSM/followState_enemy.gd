extends EnemyState

@onready var follow_timer = $FollowTimer


func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")
	actor_setup.call_deferred()
	

func actor_setup() -> void:
	#Waits until the physics frame started
	await get_tree().physics_frame
	if not enemy.nav.velocity_computed.is_connected(_velocity_computed):
		enemy.nav.velocity_computed.connect(_velocity_computed)

	if player:
		set_movement_target(player.global_position)

func set_movement_target(movement_target: Vector2) -> void:
	enemy.nav.target_position = movement_target

func _velocity_computed(safe_velocity : Vector2) -> void:
	enemy.velocity = safe_velocity

func update_physics(_delta : float) -> void:
	if player == null:
		return

	#We change the desired distance based on the fact we're seeing the player or not (raycast)
	if enemy.can_see_player:
		enemy.nav.target_desired_distance = 70.0
	else:
		enemy.nav.target_desired_distance = 2.0
	
	if not enemy.is_player_in_area: #if the player isn't near, we got a time within we can reach him, otherwise we go back in movRandomState
		if follow_timer.is_stopped():
			follow_timer.start()

	#Update player position 
	set_movement_target(player.global_position)

	#If we arrived at the target and can shoot him, shoot
	if enemy.nav.is_navigation_finished() and enemy.can_see_player:
		enemy.velocity = Vector2.ZERO
		enemy.state_machine.change_state("AttackState")
		return

	if enemy.velocity.x > 0:
		enemy.pivot.scale.x = 1
	elif enemy.velocity.x < 0:
		enemy.pivot.scale.x = -1

	#Get pathfinding information
	var current_agent_position : Vector2 = enemy.global_position
	var next_path_position : Vector2 = enemy.nav.get_next_path_position()

	#Calculate new velocity
	var new_velocity = current_agent_position.direction_to(next_path_position) * enemy.speed 

	if enemy.nav.avoidance_enabled:
		enemy.nav.set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)
	

func _on_follow_timer_timeout() -> void:
	#if we are still trying to reach the player
	if enemy.state_machine.current_state.name == "FollowState":
		#if we can't see him yet, navigation finishes 
		if not enemy.is_player_in_area:
			enemy.velocity = Vector2.ZERO
			enemy.state_machine.change_state("MovingRandomState")

func exit() -> void:
	if enemy.nav.velocity_computed.is_connected(_velocity_computed):
		enemy.nav.velocity_computed.disconnect(_velocity_computed)
	
	follow_timer.stop()