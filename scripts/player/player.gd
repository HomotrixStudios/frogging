class_name Player extends CharacterBody2D

@export var stats : Stats

@onready var animation_player = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var camera = $Camera2D
@onready var sprite = $Sprite2D

var direction : float 
var last_facing_direction : int = 1


func _ready():
	stats.health_depleted.connect(handle_death)

func _physics_process(delta: float) -> void:
	handle_direction()
	handle_animations()
	if not is_on_floor():
		velocity += get_gravity() * delta
	# print($StateMachine/AttackState/AttackCooldown.time_left)
	
	move_and_slide()

func handle_direction() -> void:
	direction = Input.get_axis("left", "right")
	if direction > 0:
		last_facing_direction = 1
	elif direction < 0:
		last_facing_direction = -1

func handle_death() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/logics/game_over.tscn")

func handle_animations():
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
