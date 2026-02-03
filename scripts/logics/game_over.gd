extends Control


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scena_prova.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()