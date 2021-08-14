extends Node

signal update_accessibility

var is_accessible = false setget set_is_accessible

func set_is_accessible(value : bool) -> void:
    is_accessible = value
    emit_signal("update_accessibility")
