extends Control

onready var _updates_popup = $UpdatesPopup

var _db_ref

func _ready() -> void:
    Firebase.Auth.login_anonymous()
    _updates_popup.show_updates(["All new accessibility options available! MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM", "Try out the new Moderator Approval action - it's Breadtastic!", "Try the new Moderator Disapproval action!", "Morning, Jamwise Gamgees!"])
    if Firebase.Auth.auth.empty():
        Firebase.Auth.connect("login_succeeded", self, "_on_auth_succeeded", [], CONNECT_ONESHOT)
    else:
        _on_auth_succeeded(null)

func _on_auth_succeeded(auth) -> void:
    _db_ref = Firebase.Database.get_database_reference("root/FunPo/Actions", { })
    _db_ref.connect("new_data_update", self, "_on_new_actions")
    _db_ref.connect("patch_data_update", self, "_on_update_actions")

func _on_new_actions(data) -> void:
    pass

func _on_update_actions(data) -> void:
    pass
