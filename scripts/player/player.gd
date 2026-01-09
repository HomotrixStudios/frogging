class_name Player extends CharacterBody2D

@export var stats : Stats

@onready var animation_player = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
