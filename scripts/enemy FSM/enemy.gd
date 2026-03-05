class_name Enemy extends CharacterBody2D

#logic variables
@export var stats : Stats
@export var state_machine : EnemyStateMachine
@export_range(10.0, 1000.0) var action_range : float
var player : Player

#animation variables
@onready var sprite = $Sprite2D
@export var animation_player : AnimationPlayer

#movement variables
# @export var speed := 45.0
var direction : int = 0
@export_range(0.0, 100.0) var x_speed : float 
@export_range(0.0, 100.0) var y_speed : float 

#attack variables 
@export var muzzle : Marker2D 

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	stats.health_depleted.connect(queue_free)

func _process(_delta) -> void:
	if velocity.x > 0:
		direction = 1
	elif velocity.x < 0:
		direction = -1
	else:
		direction = 0

func is_player_near() -> bool:
	if player == null:
		return false

	if distance_from_player() <= action_range:
		return true
	return false

func distance_from_player():
	if player == null:
		return 
	var distance := Vector2(player.position.x, player.position.y).distance_to(Vector2(position.x, position.y))
	return distance