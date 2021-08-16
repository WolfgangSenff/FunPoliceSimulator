extends HSplitContainer

signal message_rejected
signal message_accepted

onready var _timer = $Timer

func _ready() -> void:
    Globals.connect("update_autoapproval_timer", self, "_on_autoapproval_timer_updated")
    _timer.wait_time = Globals.countdown_time
    _timer.start()

func _on_ApproveButton_pressed() -> void:
    emit_signal("message_accepted")
    hide()

func _on_RejectButton_pressed() -> void:
    emit_signal("message_rejected")
    hide()

func _on_autoapproval_timer_updated(countdown_time : float) -> void:
    var current_time = _timer.wait_time - _timer.time_left
    _timer.stop()
    _timer.wait_time = countdown_time
    _timer.start(current_time if countdown_time > current_time else -1)


func _on_Timer_timeout() -> void:
    if visible:
        _on_ApproveButton_pressed()
