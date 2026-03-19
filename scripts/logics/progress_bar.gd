extends TextureProgressBar

var parent : Player
var max_value_amount : float

func _ready() -> void:
	parent = get_tree().get_first_node_in_group("Player")
	if not parent.get("stats"):
		return

	max_value_amount = parent.stats.max_health
	max_value = max_value_amount

func _process(_delta: float) -> void:
	self.value = parent.stats.health
