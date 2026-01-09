class_name Hurtbox extends Area2D

@onready var owner_stats : Stats = owner.stats

func _ready() -> void:
	monitorable = true
	monitoring = false
	print("gay")
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	match owner_stats.faction:
		Stats.Faction.PLAYER:
			set_collision_layer_value(2, true) 
		Stats.Faction.ENEMY:
			set_collision_layer_value(1, true)
	

func receive_hit(damage : int) -> void:
	owner_stats.take_damage(damage)
