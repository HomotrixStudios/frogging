extends State
class_name EnemyIdle

var move_direction : Vector2
var wander_time : float

func randomize_movement():
    # to get a direction in all axis
    move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()

    # how much time does the movement last
    wander_time = randf_range(1,3)


func enter():
    randomize_movement()

func update(delta : float):
    if wander_time > 0:
        wander_time -= delta
    else:
        randomize_movement()

func update_physics(_delta : float):
    if enemy:
        enemy.velocity = move_direction * speed
    
    var direction = player.global_position - enemy.global_position

    if direction < action_range:
        transitioned.emit(self, "follow")