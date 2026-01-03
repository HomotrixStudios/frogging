class_name HurtBox
extends Area2D

@export var stats: Stats


func _ready():
	connect("area_entered", _on_area_entered)


func _on_area_entered(hitbox: HitBox) -> void:
	stats.set_current_health(stats.current_health - hitbox.damage)
	print(stats.get_current_health())
