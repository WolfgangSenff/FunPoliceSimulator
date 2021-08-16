extends VBoxContainer

var _messages_by_id = {}

const TextMessageScene = preload("res://scenes/TextMessageBox.tscn")

func add_message_from_firebase(data) -> void:
    _messages_by_id[data.key] = data.data.message_text
    add_text_message(data.data.username, data.data.message_text, data.data.is_toxic)

func add_meme(data) -> void:
    pass

func add_text_message(username, message_text, is_toxic) -> void:
    var new_message = TextMessageScene.instance()
    add_child(new_message)
    new_message.set_username(username)
    new_message.set_text(message_text)
    new_message.set_is_toxic(is_toxic)

func add_image(username : String, image : Texture) -> void:
    pass

func edit_message(message_id, new_message) -> void:
    pass
