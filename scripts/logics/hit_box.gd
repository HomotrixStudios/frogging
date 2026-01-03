class_name HitBox
extends Area2D


@export var damage: int = 1 : set = set_damage, get = get_damage
@export var shape : CollisionShape2D

func set_damage(value: int):
	damage = value


func get_damage() -> int:
	return damage


func _on_froggy_perform_attack() -> void:
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape
	add_child(collision_shape)
