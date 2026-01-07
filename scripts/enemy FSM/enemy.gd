class_name Enemy extends CharacterBody2D

# @export var stats: Stats

#logic variables
@export var state_machine : EnemyStateMachine
@export_range(10.0, 100.0) var action_range : float
var player : Player

#animation variables
@onready var sprite = $Sprite2D
@export var animation_player : AnimationPlayer

#movement variables
@export var speed := 45.0
@export_range(0.0, 100.0) var x_movement : float 
@export_range(0.0, 100.0) var y_movement : float 


func _ready():
	player = get_tree().get_first_node_in_group("Player")

func is_player_near() -> bool:
	if player == null:
		return false
	var distance := Vector2(player.position.x, player.position.y).distance_to(Vector2(position.x, position.y))

	if distance <= action_range:
		return true
	return false
