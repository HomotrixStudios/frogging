extends EnemyState

@onready var attack_timer : Timer = $AttackTimer
@onready var projectile = preload("res://scenes/logics/projectile-test.tscn")
@export var hitbox_shape : Shape2D	

func enter() -> void:
	enemy = owner as CharacterBody2D
	attack_timer.start()
	enemy.velocity = Vector2.ZERO

func update(_delta : float) -> void:
	if not enemy.is_player_in_area or not enemy.can_see_player:
		attack_timer.stop()
		enemy.state_machine.change_state("FollowState")

	var where_to_look = enemy.global_position.direction_to(enemy.player.global_position)

	if where_to_look.x > 0:
		enemy.pivot.scale.x = 1
	elif where_to_look.x < 0:
		enemy.pivot.scale.x = -1

func shoot() -> void:
	var bullet = projectile.instantiate()
	enemy.get_parent().add_child(bullet)
	bullet.global_position = enemy.muzzle.global_position
	bullet.head_to(enemy.muzzle.global_position.direction_to(enemy.player.global_position))

	var hitbox = Hitbox.new(enemy.stats, 0.5, hitbox_shape, enemy)
	bullet.add_child(hitbox)

# func multipleShoot() -> void: #this doesn't work :(
# 	for n in range(1,4):
# 		var bullet = projectile.instantiate()
# 		bullet.spawnPos = enemy.muzzle.position + Vector2(n * 10, n * 5)
# 		bullet.spawnRot = enemy.global_rotation
# 		bullet.direction = (enemy.player.position - (enemy.muzzle.position + Vector2(n * 10, n * 5))).angle()
# 		enemy.get_parent().add_child(bullet)

func _on_attack_timer_timeout() -> void:
	shoot()
	enemy.state_machine.change_state("AttackState")
