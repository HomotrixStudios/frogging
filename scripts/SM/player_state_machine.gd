class_name PlayerStateMachine extends Node

@export var initial_state : PlayerState
@export var player : Player

var current_state : PlayerState
var states : Dictionary[String, PlayerState] = {}

func _ready() -> void:
	# to get all the states
	for child in get_children():
		if child is PlayerState:
			child.state_machine = self
			child.player = player
			states[child.name.to_lower()] = child
	
	# to enter in the inital state
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta : float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta : float) -> void:
	if current_state:
		current_state.update_physics(delta)

func change_state(new_state_name : String) -> void:
	var new_state : PlayerState = states.get(new_state_name.to_lower())

	assert(new_state, "State not found: " + new_state_name)

	if current_state:
		current_state.exit()

	new_state.enter()
	print("changed state!: " + new_state_name)
	current_state = new_state
