extends PlayerState

# Basic movement variables
@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0, 1) var acceleration := 0.1
@export_range(0,1) var deceleration := 0.1

# Dash variables
@export var dash_speed := 500.0
@export var dash_max_distance = 100.0
@export var dash_curve : Curve
@export var dash_cooldown := 1.0

# Track dash variables
var is_dashing := false
var dash_start_position := 0.0
var dash_direction := 0.0
var dash_timer := 0.0

# Jump variables
@export var jump_force := -350.0
@export_range(0, 1) var decrease_on_jump_release := 0.5
@onready var coyote_timer = $CoyoteTimer
var is_jumping := false # to avoid double jump
@onready var jump_buffer_timer = $JumpBufferTimer


func update_physics(delta : float) -> void:

	if Input.is_action_pressed("jump"): 
		if (player.is_on_floor() || !coyote_timer.is_stopped()) and !is_jumping: # If the player wants to jump and is not on floor anymore 
			player.velocity.y = jump_force
			is_jumping = true
	if player.is_on_floor():
		is_jumping = false
	
	if !is_jumping and !jump_buffer_timer.is_stopped():
		player.velocity.y = jump_force
		is_jumping = true

	if Input.is_action_just_pressed("jump") and is_jumping and jump_buffer_timer.is_stopped():
		jump_buffer_timer.start()

	if !player.is_on_floor() and coyote_timer.is_stopped():
		coyote_timer.start()

	# Modify the speed based on the input action "run"
	var speed := 0.0
	if Input.is_action_pressed("run"):
		speed = run_speed 
	else:
		speed = walk_speed
		
	# Get the input direction and handle the movement/deceleration.
	if player.direction:
		player.velocity.x = move_toward(player.velocity.x, speed * player.direction, speed * acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed * deceleration)
	
	# Dash activation
	if Input.is_action_just_pressed("dash") and player.direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = player.position.x
		dash_direction = player.direction
		dash_timer = dash_cooldown
	
	#Performs dash
	if is_dashing:
		var current_distance = abs(player.position.x - dash_start_position)
		if current_distance >= dash_max_distance or player.is_on_wall():
			is_dashing = false
		else:
			player.velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			player.velocity.y = 0

	# Reduces dash timer
	if dash_timer > 0:
		dash_timer -= delta

	if player.velocity.length() < 0.1:
		is_jumping = false
		player.state_machine.change_state("IdleState")
	
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("lick_attack"):
		player.state_machine.change_state("AttackState")

	handle_animations()

func handle_animations():
	if player.direction > 0:
		player.animation_player.play("idle_dx")
	elif player.direction < 0:
		player.animation_player.play("idle_sx")
	if is_jumping:
		if player.velocity.y < 0:
			if player.direction > 0:
				player.animation_player.play("jump_dx")
			elif player.direction < 0:
				player.animation_player.play("jump_sx")
		elif player.velocity.y > 0:
			if player.direction > 0:
				player.animation_player.play("fall_dx")
			elif player.direction < 0:
				player.animation_player.play("fall_sx")
