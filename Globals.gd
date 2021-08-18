extends Node

signal update_accessibility
signal update_autoapproval_timer(time)

var is_accessible = false setget set_is_accessible
var current_user = "BackAt50ft"
var countdown_time = 3.0 setget set_countdown_time
var current_session = null

func _ready() -> void:
    get_tree().set_auto_accept_quit(false)

func set_is_accessible(value : bool) -> void:
    is_accessible = value
    emit_signal("update_accessibility")

func set_countdown_time(time) -> void:
    countdown_time = time
    emit_signal("update_autoapproval_timer", countdown_time)

var _quit_once = false

func _notification(what: int) -> void:
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST and not _quit_once:
        _quit_once = true
        var gui = get_tree().get_nodes_in_group("GUI")[0]
        gui.delete_session()
        yield(get_tree().create_timer(0.5), "timeout")
        get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
    elif what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST and _quit_once:
        get_tree().quit()
