extends Control

func _ready() -> void:
	$VBoxContainer/Play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/scena 3.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/work_in_progress.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/work_in_progress.tscn")