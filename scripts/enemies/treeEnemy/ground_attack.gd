extends EnemyState

@export var hitbox_shape : Shape2D
@export var jump_height := 100.0
@export var lift_duration := 0.5
@export var slam_duration := 0.25

@onready var attack_timer : Timer = $GroundAttackTimer

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_position : Vector2
var direction : Vector2
var ground_position_y : float #initial ground position

func enter() -> void:
    attack_timer.start()
    enemy.velocity = Vector2.ZERO

    enemy.animation_player.play("jump")

    ground_position_y = enemy.global_position.y
    target_position = enemy.player.global_position

    enemy.velocity = calculate_arc(enemy.global_position, target_position)


func update_physics(_delta : float) -> void:
    handle_animations()



func hit() -> void:
    var hitbox = Hitbox.new(enemy.stats, 1.0, hitbox_shape, enemy)
    enemy.add_child(hitbox)
    hitbox.global_position = Vector2(enemy.global_position.x, enemy.global_position.y + 20)


func calculate_arc(start: Vector2, target: Vector2) -> Vector2:
    #To ensure that jump height is enough
    var actual_height = max(jump_height, start.y - target.y + 20.0)

    var vel_y = -sqrt(2 * gravity * actual_height)

    var time_up = abs(vel_y) / gravity

    var fall_distance = (target.y - start.y) + actual_height

    #If target is not reachable
    if fall_distance < 0.0:
        fall_distance = 0.0

    var time_down = sqrt(2 * fall_distance / gravity)

    var total_time = time_up + time_down

    var vel_x = (target.x - start.x) / total_time

    return Vector2(vel_x, vel_y)


func _on_ground_attack_timer_timeout() -> void:
    enemy.cooldown_timer.start()
    enemy.state_machine.change_state("FollowState")


func exit() -> void:
    enemy.velocity = Vector2.ZERO


func handle_animations() -> void:
    if enemy.velocity.y > 0:
        enemy.animation_player.play("going_down")
    elif enemy.velocity.y == 0:
        enemy.animation_player.play("slam_ground")