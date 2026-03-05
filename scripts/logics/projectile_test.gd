extends CharacterBody2D

@export var speed : int = 200

var direction : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
    global_position = spawnPos
    global_rotation = spawnRot

func _physics_process(delta: float) -> void:
    velocity = Vector2(speed, get_gravity().y*delta).rotated(direction)
    move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body == self or body.find_parent("FlyEnemy"):
        return
    if body is Player:
        body.stats.take_damage(30) #yes, I know it sucks. Gotta fix it
    queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
    if area.find_parent("FlyEnemy"): 
       return 
    queue_free()
