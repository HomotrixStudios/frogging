class_name Enemy extends CharacterBody2D

@export var action_range := 10.0
var player : Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func is_player_near():
	if player == null:
		return false
	
	var distance := Vector2(owner.position.x, owner.position.y).distance_to(Vector2(player.position.x, player.position.y))
	return distance < action_range