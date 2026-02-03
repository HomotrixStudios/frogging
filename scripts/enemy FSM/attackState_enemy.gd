extends EnemyState

@onready var attack_timer : Timer = $AttackTimer
@onready var projectile = preload("res://scenes/logics/projectile-test.tscn")
	

func enter() -> void:
	attack_timer.start()
	enemy.velocity = Vector2.ZERO

func update(_delta : float) -> void:
	if not enemy.is_player_near():
		attack_timer.stop()
		enemy.state_machine.change_state("MovingRandomState")

func shoot() -> void:
	var bullet = projectile.instantiate()
	bullet.direction = (enemy.player.position - enemy.muzzle.position).angle()
	bullet.spawnPos = enemy.muzzle.position
	bullet.spawnRot = enemy.global_rotation
	enemy.get_parent().add_child(bullet)

func multipleShoot() -> void: #this doesn't work :(
	for n in range(1,4):
		var bullet = projectile.instantiate()
		bullet.spawnPos = enemy.muzzle.position + Vector2(n * 10, n * 5)
		bullet.spawnRot = enemy.global_rotation
		bullet.direction = (enemy.player.position - (enemy.muzzle.position + Vector2(n * 10, n * 5))).angle()
		enemy.get_parent().add_child(bullet)

func _on_attack_timer_timeout() -> void:
	shoot()
