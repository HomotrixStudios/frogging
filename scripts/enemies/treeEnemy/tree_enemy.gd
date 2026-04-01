extends CharacterBody2D

@export var stats : Stats
@export var speed : float = 50.0
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var pivot : Node2D = $Pivot
@onready var point_a : Marker2D = $PointA
@onready var point_b : Marker2D = $PointB
@onready var sight_area : Area2D = $SightArea
@onready var muzzle : Marker2D = $Pivot/Muzzle
@onready var cooldown_timer : Timer = $CooldownTimer

var is_player_in_area : bool = false
var pos_a : Vector2
var pos_b : Vector2
var can_see_player : bool = true
var player : Player

var attack_options = ["MeeleAttackState", "BarrierAttackState"]

func _ready() -> void:
    player = get_tree().get_first_node_in_group("Player")
    stats.health_depleted.connect(queue_free) #to fucking die
    animation_player.play("RESET")
    pos_a = point_a.global_position
    pos_b = point_b.global_position


func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += get_gravity().y * delta 
    handle_animations()
    check_sight_area()
    
    move_and_slide()


func check_sight_area() -> void:
    var bodies_in_area = sight_area.get_overlapping_bodies() #gets all the bodies in the area
    for body in bodies_in_area:
        if body == player: 
            is_player_in_area = true
            return
    is_player_in_area = false


func _on_damage_area_area_entered(area: Area2D) -> void:
    if area.get_parent() is Player:
        area.receive_hit(stats.defense)


func handle_animations() -> void:
    if state_machine.current_state.name == "MovingRandomState" or state_machine.current_state.name == "FollowState":
        if velocity == Vector2.ZERO:
            animation_player.play("idle")
        else:
            animation_player.play("move")

    
    
