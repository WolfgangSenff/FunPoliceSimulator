extends Control

onready var _updates_popup = $UpdatesPopup

func _ready() -> void:
    _updates_popup.show_updates(["All new accessibility options available!", "Try out the new Moderator Approval action - it's Breadtastic!", "Try the new Moderator Disapproval action!", "Morning, Jamwise Gamgees!"])
