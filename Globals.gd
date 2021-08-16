extends Node

signal update_accessibility
signal update_autoapproval_timer(time)

var is_accessible = false setget set_is_accessible
var current_user = "BackAt50ft"
var countdown_time = 3.0 setget set_countdown_time

func set_is_accessible(value : bool) -> void:
    is_accessible = value
    emit_signal("update_accessibility")

func set_countdown_time(time) -> void:
    countdown_time = time
    emit_signal("update_autoapproval_timer", countdown_time)
