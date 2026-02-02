extends CharacterBody2D

@export var speed : int = 100

var direction : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
    global_position = spawnPos
    global_rotation = spawnRot

func _physics_process(_delta: float) -> void:
    velocity = Vector2(speed, 0).rotated(direction)
    move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
    pass


func _on_area_2d_area_entered(area: Area2D) -> void:
    pass
