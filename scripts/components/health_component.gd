class_name Health
extends Node

signal max_health_changed(value: int)
signal health_changed(value: int)
signal health_depleted

@export var max_health := 3 : set = set_max_health, get = get_max_health

@onready var current_health := max_health : set = set_current_health, get = get_current_health

func set_max_health(value : int):
	value = 1 if value <= 0 else value

	if not (value == max_health):
		max_health = value
		emit_signal("max_health_changed", max_health)

func get_max_health() -> int:
	return max_health

func set_current_health(value : int):
	if value == current_health:
		return
	
	if value <= 0:
		emit_signal("health_depleted")
	
	current_health = value
	emit_signal("health_changed", current_health)

func get_current_health() -> int:
	return current_health
