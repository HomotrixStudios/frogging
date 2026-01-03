extends Node
class_name Stats

# Based on the tutorial by "Queble" - a very simplified version withouth the xp and level stats (so far)
# It was a resource once, but I know nothing about resources so I changed it to Node

@export var max_health : float = 100.0
@export var defense : float = 10.0
@export var attack : float = 10.0
@export var speed : float = 30.0


signal health_depleted
signal health_changed(current_health : float, max_health : float)

var current_health : float = 0.0 : set = set_current_health, get = get_current_health

func _init() -> void:
	setup_stats.call_deferred()
	

func setup_stats() -> void:
	current_health = max_health
	

func set_current_health(new_value : float) -> void:
	current_health = clampf(new_value, 0, max_health)
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		health_depleted.emit()

func get_current_health():
	return current_health
