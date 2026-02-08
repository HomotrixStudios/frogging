extends Control

func _ready() -> void:
	$VBoxContainer/Play.grab_focus()

func _on_play_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
