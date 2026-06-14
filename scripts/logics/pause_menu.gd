extends Control

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")
	self.hide()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			resume()
			animation_player.play_backwards("blur")
		else:
			pause()
			animation_player.play("blur")

func resume() -> void:
	self.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false


func pause() -> void:
	self.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true


func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	#actually this doens't reset resource's value (e.g. health)
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/logics/main_menu.tscn")
