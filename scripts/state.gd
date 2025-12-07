extends Node
class_name State

@export var enemy : CharacterBody2D
@export var speed := 40.0

##The range of action in which the enemy will follow the player
@export_range(10, 50) var action_range := 25 

@onready var player = get_tree().get_first_node_in_group("Player")

signal transitioned

func enter():
    pass

func exit():
    pass

func update(_delta : float):
    pass

func update_physics(_delta : float):
    pass