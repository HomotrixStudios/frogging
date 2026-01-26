extends ProgressBar

var parent
var max_value_amount : float

func _ready() -> void:
	parent = get_parent()
	if not parent.get("stats"):
		return
	# parent.stats.health_changed.connect(_on_health_changed)
	# _on_health_changed(parent.stats.health, parent.stats.max_health)
	max_value_amount = parent.stats.max_health
	max_value = max_value_amount

func _process(_delta: float) -> void:
	self.value = parent.stats.health

# func _on_health_changed(_value : int, _max_value : int) -> void:
# 	max_value = _max_value
# 	value = _value