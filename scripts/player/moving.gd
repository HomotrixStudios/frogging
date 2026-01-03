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


func update_physics(delta : float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() || !coyote_timer.is_stopped()) and !is_jumping: # If the player wants to jump and is not on floor anymore 
		player.velocity.y = jump_force
		is_jumping = true
	elif player.is_on_floor():
		is_jumping = false

	if !player.is_on_floor() and coyote_timer.is_stopped():
		coyote_timer.start()

	# Modify the jump height based on the release of jump button
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= decrease_on_jump_release * delta	

	# Modify the speed based on the input action "run"
	var speed := 0.0
	if Input.is_action_pressed("run"):
		speed = run_speed 
	else:
		speed = walk_speed
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		player.velocity.x = move_toward(player.velocity.x, speed * direction, speed * acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed * deceleration)
	
	# Dash activation
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = player.position.x
		dash_direction = direction
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
		player.state_machine.change_state("IdleState")
	
	handle_animation(direction)

func handle_animation(direction : float):
	player.animation_player.play("idle")
	if direction == 1:
		player.sprite.play("idle_dx")
	elif direction == -1:
		player.sprite.play("idle_sx")
