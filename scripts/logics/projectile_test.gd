extends CharacterBody2D

@export var speed : int = 200
var direction : float
var spawnPos : Vector2
var spawnRot : float

@onready var shape = $CollisionShape2D

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed, get_gravity().y*delta).rotated(direction)
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.find_parent("FlyEnemy"):
		return
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is FlyEnemy or body != self:
		print(body)
		queue_free()