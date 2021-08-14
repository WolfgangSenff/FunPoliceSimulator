extends Control

onready var _label = $MarginContainer/RichTextLabel
onready var _anim = $AnimationPlayer

func set_update_text(text : String) -> void:
    _label.bbcode_text = "* NEW! * - " + text


func _on_MarginContainer_mouse_entered() -> void:
    _anim.play("Hover")


func _on_MarginContainer_mouse_exited() -> void:
    _anim.play_backwards("Hover")
