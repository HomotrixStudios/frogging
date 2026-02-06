extends PlayerState

@export var hitbox_shape : Shape2D
@onready var attack_cooldown = $AttackCooldown
@onready var attack_timer = $AttackTimer


func enter():
	if attack_cooldown.time_left > 0: #if the combo-timer fails, this will say when we can attack again
		return

	#this timer will know if we can do a combo
	if attack_timer.is_stopped():
		attack_timer.start()
	print("Started!")


	var hit_log : Hitlog = Hitlog.new()
	var hitbox = Hitbox.new(player.stats, 0.5, hitbox_shape, player, hit_log)
	player.add_child(hitbox)
	hitbox.position += Vector2(15.0, 0) * player.last_facing_direction
	hitbox.hitting.connect(_on_hit)

	# for n in range(1,4):
	# 	var hitbox = Hitbox.new(player.stats, 0.5, hitbox_shape, hit_log)
	# 	hitbox.position = player.position + Vector2(n * 10, n*5)
	# 	add_child(hitbox)
	# 	hitbox.hitting.connect(_on_hit)

func update(_delta : float) -> void:
	if Input.is_action_pressed("attack") and attack_timer.time_left > 0 and attack_timer.time_left < attack_timer.wait_time:
		print("daje")

	if player.velocity.length() > 0.1:
		player.state_machine.change_state("MovingState")
	else:
		player.state_machine.change_state("IdleState")
	handle_animations()

func exit() -> void:
	if attack_cooldown.is_stopped():
		attack_cooldown.start()

func _on_hit():
	player.camera.apply_shake()

func handle_animations():
	if player.velocity.y != 0:
		player.animation_player.play("jumpAttack")
		print("jumpAttack!")
	if Input.is_action_pressed("attack"):
		player.animation_player.play("attack1")
	elif Input.is_action_pressed("lick_attack"):
		if player.last_facing_direction == 1:
			player.animation_player.play("lick_attack")
		elif player.last_facing_direction == -1:
			player.animation_player.play("lick_attack")
