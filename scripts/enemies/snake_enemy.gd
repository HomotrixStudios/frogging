extends CharacterBody2D

@export var stats : Stats
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var sprite : Sprite2D = $Pivot/Sprite2D
@onready var raycast : RayCast2D = $Pivot/RayCast2D
@onready var point_a : Marker2D = $PointA
@onready var point_b : Marker2D = $PointB
@onready var pivot : Node2D = $Pivot
var can_see_player : bool = true
var is_player_in_area : bool = false
var pos_a : Vector2
var pos_b : Vector2

var speed : float = 45.0
const gravity = 1000

var player : Player 

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	stats.health_depleted.connect(queue_free) #to fucking die
	animation_player.play("RESET")
	pos_a = point_a.global_position
	pos_b = point_b.global_position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta 
	check_raycast()
	move_and_slide()
	handle_animations()

	# if velocity.x > 0:
	# 	pivot.scale.x = 1
	# elif velocity.x < 0:
	# 	pivot.scale.x = -1

func check_raycast() -> void:
	raycast.to_local(player.global_position)
	# can_see_player = raycast.is_colliding()


func handle_animations():
	if not animation_player.is_playing():
		animation_player.play("idle")


func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.receive_hit(stats.defense)


func _on_sight_area_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		is_player_in_area = true


func _on_sight_area_body_exited(body: CharacterBody2D) -> void:
	if body is Player:
		is_player_in_area = false
