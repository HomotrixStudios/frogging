extends PlayerState

# Jump variables
@export var jump_force := -350.0
@export_range(0, 1) var decrease_on_jump_release := 0.5
@onready var coyote_timer = $CoyoteTimer
var is_jumping := false # to avoid double jump 


func enter() -> void:
	player.velocity.y = jump_force
	is_jumping = true

func update_physics(delta : float):
	# Modify the jump height based on the release of jump button
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= decrease_on_jump_release * delta

	if player.velocity.length() < 0.1:
		player.state_machine.change_state("IdleState")
	else:
		player.state_machine.change_state("MovingState")
		
	if Input.is_action_just_pressed("jump"):
		pass
	
	# Handle jump.
	if (player.is_on_floor() || !coyote_timer.is_stopped()) and !is_jumping: # If the player wants to jump and is not on floor anymore 
		pass
		
	if player.is_on_floor():
		if player.velocity.length() < 0.1:
			player.state_machine.change_state("IdleState")
		else:
			player.state_machine.change_state("MovingState")
		is_jumping = false
