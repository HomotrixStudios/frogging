extends Area2D

@export var speed : int = 200
var direction : Vector2 = Vector2.ZERO

func head_to(trajectory : Vector2):
	direction = trajectory.normalized()
	rotation = trajectory.angle()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.find_parent("FlyEnemy"):
		return
	print(area)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body is FlyEnemy or body != self:
		print(body)
		queue_free()
