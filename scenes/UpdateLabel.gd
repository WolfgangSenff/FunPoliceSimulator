extends Control

onready var _label = $MarginContainer/RichTextLabel
onready var _size_tween = $MarginContainer/Tween

func set_update_text(text : String) -> void:
    _label.bbcode_text = "* NEW! * - " + text
    yield(get_tree(), "idle_frame")
    _size_tween.interpolate_method(self, "_interpolate_rect_size_y", 0, 44, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN, 0.0)
    _size_tween.start()
    yield(_size_tween, "tween_completed")
    _label.fit_content_height = true


func _interpolate_rect_size_y(new_value) -> void:
    self.rect_size.y = new_value
