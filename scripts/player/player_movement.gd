class_name Player extends CharacterBody2D

# Basic movement variables
@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0, 1) var acceleration := 0.1
@export_range(0,1) var deceleration := 0.1

# Jump variables
@export var jump_force := -350.0
@export_range(0, 1) var decrease_on_jump_release := 0.5
@onready var coyote_timer = $CoyoteTimer
var is_jumping := false # to avoid double jump (temporarily)

@onready var sprite = $AnimatedSprite2D
var last_facing_direction : float

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

# Dash effect variables
var tween := create_tween() # Lightweight object used for general-purpose animation via script
signal start_trail # Sets the process of the trail to true
signal stop_trail # Sets the process of the trail to false

var current_state

func _ready() -> void:
	change_state("idleState")

func change_state(new_state_name : String):
	if current_state:
		current_state.exit_state()
	current_state = get_node(new_state_name)
	if current_state:
		current_state.enter_state(self)

func _physics_process(delta: float) -> void: 

	if current_state:
		current_state.handle_input(delta)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_jumping = false
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_timer.is_stopped()) and !is_jumping: # If the player wants to jump and is not on floor anymore 
		velocity.y = jump_force
		is_jumping = true
	
	# Detects floor before updating
	var was_on_floor = is_on_floor() 
	
	move_and_slide() #This updates every collision detected by kinematicbody
	
	# If the player isn't on floor anymore
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
	# Modify the jump height based on the release of jump button
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decrease_on_jump_release * delta
	
	# Modify the speed based on the input action "run"
	var speed := 0.0
	if Input.is_action_pressed("run"):
		speed = run_speed
		emit_signal("start_trail") 
	else:
		speed = walk_speed
		if not is_dashing: # Otherwise it would interfere with the signal
			emit_signal("stop_trail")
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, speed * direction, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration)

	handle_animations(direction)
	
	# Dash activation
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		reset_tween() 
		tween.tween_method(setShader_BlinkIntensity, 1.0, 0.0, 0.5) # This calls the function blinkIntensity
		emit_signal("start_trail")
	
	#Performs dash
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
			emit_signal("stop_trail")
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
	
	# Reduces dash timer
	if dash_timer > 0:
		dash_timer -= delta

# To avoid overriding more than a tween to a single object
func reset_tween() -> void:   
	if tween:
		tween.kill()
	tween = create_tween()

# Applies the shader set in the AnimatedSprite2D
func setShader_BlinkIntensity(new_value: float): 
	sprite.material.set_shader_parameter("blink_intensity", new_value)

func handle_animations(direction) -> void:
	if direction == 1:
		sprite.play("idle_dx")
	elif direction == -1:
		sprite.play("idle_sx")

	

func _on_animation_timer_timeout() -> void:
	sprite.play("idle_special")
