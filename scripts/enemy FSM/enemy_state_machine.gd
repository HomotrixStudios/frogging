class_name EnemyStateMachine extends Node

@export var initial_state : EnemyState
@export var enemy : Enemy

var current_state : EnemyState
var states: Dictionary[String, EnemyState] = {}

func _ready() -> void:
	# to get all childrens
	for child in get_children():
		if child is EnemyState:
			child.state_machine = self
			child.enemy = enemy
			states[child.name.to_lower()] = child
		
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		# print(current_state)
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update_physics(delta)

func change_state(new_state_name : String) -> void:
	var new_state : EnemyState = states.get(new_state_name.to_lower())

	assert(new_state, "State not found: " + new_state_name)

	if current_state: 
		current_state.exit()

	new_state.enter()
	current_state = new_state
