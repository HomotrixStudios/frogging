extends RayCast2D

func _process(_delta):
    var direction := Input.get_axis("left", "right")    
    if direction == 1:
        target_position.x = 30.0
    elif direction == -1:
        target_position.x = -30.0