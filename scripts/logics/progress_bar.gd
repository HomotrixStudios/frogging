extends ProgressBar

func _ready() -> void:
	if owner.get("stats"):
		owner.stats.health_changed.connect(_on_health_changed)
		_on_health_changed(owner.stats.health, owner.stats.max_health)


func _on_health_changed(_value : int, _max_value : int) -> void:
	max_value = _max_value
	value = _value