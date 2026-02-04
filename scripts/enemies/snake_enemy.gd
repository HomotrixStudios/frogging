class_name SnakeEnemy extends Enemy

const gravity = 1000

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta 
    move_and_slide()
    handle_animations()


func handle_animations():
    animation_player.play("idle")
    if direction == 1:
        sprite.flip_h = false
    elif direction == -1:
        sprite.flip_h = true