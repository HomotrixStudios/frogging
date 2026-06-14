class_name Hurtbox extends Area2D

@onready var owner_stats : Stats = owner.stats

func _ready() -> void:
	monitorable = true
	monitoring = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	match owner_stats.faction:
		Stats.Faction.PLAYER:
			set_collision_layer_value(2, true) 
		Stats.Faction.ENEMY:
			set_collision_layer_value(1, true)


func receive_hit(damage : int) -> void:
	# print(owner, "before: ", owner_stats.health)
	var animation = owner.animation_player
	owner_stats.take_damage(damage) 
	# print(owner, "after: ", owner_stats.health)
	if owner_stats.health > 0:
		animation.play("flash_hit")
	owner.animation_priority = true
