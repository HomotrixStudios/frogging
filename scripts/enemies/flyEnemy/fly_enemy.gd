extends Enemy

@export var stats : Stats

func _physics_process(_delta: float) -> void:
	move_and_slide()
