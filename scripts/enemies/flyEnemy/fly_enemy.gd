class_name FlyEnemy extends CharacterBody2D

#logic variables
@export var stats : Stats
@export var state_machine : EnemyStateMachine
@export_range(10.0, 1000.0) var action_range : float
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var shapecast : ShapeCast2D = $ShapeCast2D
@onready var sight_area : Area2D = $SightArea
var player : Player
@onready var pivot : Node2D = $Pivot
@onready var point_a : Marker2D = $PointA
@onready var point_b : Marker2D = $PointB

var pos_a : Vector2
var pos_b : Vector2

#animation variables
@onready var sprite : Sprite2D = $Pivot/Sprite2D
@export var animation_player : AnimationPlayer
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

#movement variables
@export var speed := 60.0
var can_see_player : bool = false
var is_player_in_area : bool = false
#attack variables 
@onready var muzzle : Marker2D = $Pivot/Marker2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	stats.health_depleted.connect(queue_free) #to fucking die

	#to fix the points to the world level
	pos_a = point_a.global_position
	pos_b = point_b.global_position


func _physics_process(_delta: float) -> void:

	check_raycast()
	check_sight_area()
	
	handle_animations()
	move_and_slide() #I want to slide too

	
func handle_animations() -> void:
	if not animation_player.is_playing():
		animation_player.play("idle")


func check_sight_area() -> void:
	var bodies_in_area = sight_area.get_overlapping_bodies() #gets all the bodies in the area
	for body in bodies_in_area:
		if body.is_in_group("Player"): 
			is_player_in_area = true
			return
	is_player_in_area = false


func check_raycast() -> void:
	if player:
		
		var player_center = player.global_position + Vector2(0,-10)

		shapecast.global_position = muzzle.global_position
		var aim = shapecast.to_local(player_center)
		
		#so if the player is attached to the wall, we won't collide with the wall
		var margin = 15.0
		shapecast.target_position = aim - (aim.normalized() * margin) #to point the raycast to the player
		
		shapecast.force_shapecast_update() #to force update withouth waiting 1 frame
		
		can_see_player = not shapecast.is_colliding()
		
