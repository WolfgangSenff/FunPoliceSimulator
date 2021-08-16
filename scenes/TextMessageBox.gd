extends Control

signal rejected_toxic_message
signal rejected_nontoxic_message

signal approved_toxic_message
signal approved_nontoxic_message

var _username setget set_username
var _text = "" setget set_text
var _is_toxic = false setget set_is_toxic

func set_username(username : String) -> void:
    _username = username
    $NameContainer/Username.text = _username + ":"

func set_text(text : String) -> void:
    _text = text
    $HSplitContainer/TextContainer/MessageText.text = text

func set_is_toxic(value : bool) -> void:
    _is_toxic = value

func _on_ModerationControl_message_rejected() -> void:
    if _is_toxic:
        emit_signal("rejected_toxic_message")
    else:
        emit_signal("rejected_nontoxic_message")

    self._text = "  *****"


func _on_ModerationControl_message_accepted() -> void:
    if _is_toxic:
        emit_signal("approved_toxic_message")
    else:
        emit_signal("approved_nontoxic_message")
