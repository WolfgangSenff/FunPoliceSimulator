extends Control

onready var _label = $MarginContainer/RichTextLabel

func set_update_text(text : String) -> void:
    _label.bbcode_text = "* NEW! * - " + text
