class_name Stats extends Resource

# I want to add a buff/debuff system here 

enum Faction {
    PLAYER,
    ENEMY,
}

signal health_depleted
signal health_changed(cur_health : int)

@export var max_health : int = 100
@export var defense : int = 10
@export var damage : int = 10
@export var faction : Faction = Faction.ENEMY

var health : int = 0 : set = set_health

func _init() -> void:
    setup_stats.call_deferred()

func setup_stats() -> void:
    health = max_health

func take_damage(amount : int) -> void:
    health -= amount
    set_health(health)

func set_health(new_value : int) -> void:
    health = new_value
    health_changed.emit(health)
    if health <= 0:
        # print("emitting")
        health_depleted.emit()
   