extends PlayerState

@export var hitbox_shape : Shape2D
var attack_timer : float = 0.3

func enter():
	if Input.is_action_pressed("attack"):
		var hitbox = Hitbox.new(player.stats, 0.5, hitbox_shape, player)
		player.add_child(hitbox)
		hitbox.position += Vector2(15.0, 0) * player.last_facing_direction
		hitbox.hitting.connect(_on_hit)
	

	# var hit_log : Hitlog = Hitlog.new()
	# for n in range(1,4):
	# 	var hitbox = Hitbox.new(player.stats, 0.5, hitbox_shape, hit_log)
	# 	hitbox.position = player.position + Vector2(n * 10, n*5)
	# 	add_child(hitbox)
	# 	hitbox.hitting.connect(_on_hit)

func update(delta : float) -> void:
	attack_timer -= delta
	if attack_timer <= 0:
		if player.velocity.length() > 0.1:
			player.state_machine.change_state("MovingState")
		else:
			player.state_machine.change_state("IdleState")
	handle_animations()

func _on_hit():
	owner.camera.apply_shake()

func handle_animations():
	if Input.is_action_pressed("lick_attack"):
		if player.last_facing_direction == 1:
			player.animation_player.play("lick_attack")
		elif player.last_facing_direction == -1:
			player.animation_player.play("lick_attack")