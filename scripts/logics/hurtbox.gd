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
    var animation = owner.animation_player
    animation.play("flash_hit")
    if owner is Player:
        owner.animation_priority = true
    owner_stats.take_damage(damage)
