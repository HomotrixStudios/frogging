extends Node2D

func _process(_delta: float) -> void:
    if not get_tree().get_nodes_in_group("Enemy"):
        await get_tree().create_timer(2.0).timeout
        get_tree().change_scene_to_file("res://scenes/logics/win_scene.tscn")
