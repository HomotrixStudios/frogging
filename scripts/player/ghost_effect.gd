extends Sprite2D

func _ready() -> void:
    ghosting()

func set_property(pos : Vector2, flip : bool) -> void:
    position = pos
    flip_h = flip

func ghosting():
    var tween_fade = get_tree().create_tween()

    tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.75)
    await tween_fade.finished

    queue_free()
