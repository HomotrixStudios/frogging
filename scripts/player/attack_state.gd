extends PlayerState

@export var hitbox_shape : Shape2D
@export var spin_hitbox_shape : Shape2D
#I don't remember the diff between these two, I hardcoded them
@onready var attack_cooldown = $AttackCooldown
@onready var attack_timer = $AttackTimer

#to manage the animations for the regular attack
var combo : int = 0

#used for knockback
var attack_direction : int # -1 or 1
@export var knockback_intensity : int = 200

#used for bouncy effect 
var spinning : bool = false
@export var bounce_force : float = 300.0 #intensity of horizontal knockback
@export var small_lift : float = -100.0
@export var bounce_lift : float = -250.0 #intensity of vertical 

func enter():
	handle_animations()

	#this timer will know if we can do a combo
	if attack_cooldown.time_left > 0: #if the combo-timer fails, this will say when we can attack again
		return
	
	if attack_timer.is_stopped():
		attack_timer.start()

	#HOLY CODE (fanculo)
	if attack_timer.time_left > 0 and attack_timer.time_left < attack_timer.wait_time:
		combo += 1
		attack_timer.start()
		if combo == 3:
			combo = 0
	else:
		combo = 0
	
	var hit_log : Hitlog = Hitlog.new()

	if Input.is_action_pressed("down"):
		spinning = true
				
		var spin_hitbox = Hitbox.new(player.stats, 0.6, spin_hitbox_shape, player, hit_log)
		player.add_child(spin_hitbox)
		spin_hitbox.global_position = player.position 
		spin_hitbox.hitting.connect(_on_hit)
		spin_hitbox.hitbox_collided.connect(_on_spinning_hitbox_hit)
		return

	var hitbox = Hitbox.new(player.stats, 0.5, hitbox_shape, player, hit_log)
	player.add_child(hitbox)
	hitbox.position += Vector2(15.0, 0) * player.last_facing_direction
	attack_direction = player.last_facing_direction
	hitbox.hitting.connect(_on_hit)
	
		

func update(_delta : float) -> void:
	if player.velocity.length() > 0.1:
		player.state_machine.change_state("MovingState")
	else:
		player.state_machine.change_state("IdleState")

func exit() -> void:
	if spinning:
		spinning = false #I don't think this is necessary, 'meglio prevenire che curare'
	if attack_cooldown.is_stopped():
		attack_cooldown.start()

func _on_hit() -> void:
	player.camera.apply_shake()
	player.velocity.x = -attack_direction * knockback_intensity

func _on_spinning_hitbox_hit(body) -> void:
	#we take the direction of the hit
	var hit_direction = (player.global_position - body.global_position).normalized()
	
	# #we choose an axis based on the velocity of the player
	if abs(player.velocity_before_collision.x) > abs(player.velocity_before_collision.y):
		player.velocity.x = sign(player.velocity_before_collision.x) * bounce_force
		player.velocity.y = small_lift #little knockback on the y axis too, otherwise it would be boring
	else:
		player.velocity.y = sign(hit_direction.y) * bounce_force

# bacon in padella
# bacon croccante sulla padella
# zucca a cremina
# sottiletta dentro zucca
# butta tutta la pasta

func handle_animations() -> void:
	player.animation_priority = true
	if Input.is_action_pressed("lick_attack"):
		player.animation_player.play("lick_attack")
		return	
	
	if Input.is_action_pressed("down"):
		player.animation_player.play("spin_attack")
		
		return

	if player.velocity.y != 0:
		player.animation_player.play("jumpAttack")
		return

	match combo:
		0:	
			player.animation_player.play("attack1")
		1:
			player.animation_player.play("attack2")
		2: 
			player.animation_player.play("attack3")
	return
	
	
