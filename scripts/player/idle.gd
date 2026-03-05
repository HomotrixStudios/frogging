extends PlayerState

func update(_delta : float) -> void:
    if Input.get_vector("left", "right", "ui_up", "ui_down") or player.velocity.length() > 0.1 or Input.is_action_just_pressed("jump"):
        player.state_machine.change_state("MovingState")
    
    if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("lick_attack"):
        player.state_machine.change_state("AttackState")
    
    handle_animations()


func handle_animations(): 
    if not player.animation_player.is_playing():
        player.animation_player.play("idle")