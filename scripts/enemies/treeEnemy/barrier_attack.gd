extends EnemyState

@export var hitbox_shape : Shape2D
@onready var barrier_attack_timer : Timer = $BarrierTimer

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	enemy.animation_player.play("barrier_attack")
	barrier_attack_timer.start()


func hit() -> void:
	var hitbox = Hitbox.new(enemy.stats, 1.0, hitbox_shape, enemy)
	enemy.add_child(hitbox)
	hitbox.global_position = Vector2(enemy.global_position.x, enemy.global_position.y + 10)


func _on_barrier_timer_timeout() -> void:
	enemy.cooldown_timer.start()
	enemy.state_machine.change_state("FollowState")
