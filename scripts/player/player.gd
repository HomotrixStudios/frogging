class_name Player extends CharacterBody2D

@export var stats : Stats
@export var ghost_effect : PackedScene

@onready var animation_player = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var camera = $Camera2D
@onready var sprite = $Sprite2D
@onready var pivot : Node2D = $Pivot
@onready var wall_check_top : RayCast2D = $Pivot/WallCheckTop
@onready var wall_check_bottom : RayCast2D = $Pivot/WallCheckBottom
@onready var hitbox_spawn : Marker2D = $Pivot/HitboxSpawn

#helps me to avoid overlapping animations
var animation_priority : bool = false
#I think I could avoid using these two, but I won't
var direction : Vector2 
var last_facing_direction : int = 1
var velocity_before_collision : Vector2


func _ready():
	stats.health_depleted.connect(handle_death)
	# set_floor_max_angle(35)

func _physics_process(delta: float) -> void:
	handle_direction()
	handle_animations()
		
	if is_on_ceiling(): #If we hit the ceiling we want to give a little impact on the velocity of the player
		if velocity.y < 0:
			velocity.y = 10.0
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity_before_collision = velocity

	move_and_slide()
	

func handle_direction() -> void:
	direction = Input.get_vector("left", "right", "up", " ")
	#Based on the direction we rotate/scale the pivot containing raycasts and hitbox marker
	if direction.y == -1:
		if pivot.scale.x == 1:
			pivot.rotation_degrees = -90
		else:
			pivot.rotation_degrees = 90
	else:
		pivot.rotation_degrees = 0
	if direction.x > 0:
		pivot.scale.x = 1
		last_facing_direction = 1
	elif direction.x < 0:
		pivot.scale.x = -1
		last_facing_direction = -1

func handle_death() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/logics/game_over.tscn")

func handle_animations():
	if last_facing_direction == 1:
		sprite.flip_h = false
	elif last_facing_direction == -1:
		sprite.flip_h = true
