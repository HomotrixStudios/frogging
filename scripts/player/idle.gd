extends PlayerState

func update(_delta : float) -> void:
	if Input.get_vector("left", "right", "ui_up", "ui_down") or player.velocity.length() > 0.1 or Input.is_action_just_pressed("jump"):
		player.state_machine.change_state("MovingState")
	
		
