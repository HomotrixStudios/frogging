extends EnemyState

func enter() -> void:
	enemy.set_physics_process(false)
	enemy.set_process(false)
	enemy.animation_player.play("death")

func _process(_delta: float) -> void:
	# if enemy.animation_player.is_playing():
	# 	return
	await enemy.animation_player.animation_finished
	enemy.queue_free()
