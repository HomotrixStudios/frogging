extends Control

func _ready() -> void:
	$VBoxContainer/Play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/scena 3.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
