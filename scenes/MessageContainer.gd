extends VBoxContainer

var _messages_by_id = {}

const TextMessageScene = preload("res://scenes/TextMessageBox.tscn")
const ImageMessageScene = preload("res://scenes/ImageMessageBox.tscn")

func add_message_from_firebase(data) -> void:
    _messages_by_id[data.key] = data.data.message_text
    if data.data.has("meme_link"):
        add_image(data.data.username, data.data.message_text, data.data.meme_link)
    else:
        add_text_message(data.data.username, data.data.message_text, data.data.is_toxic)

func add_meme(data) -> void:
    pass

func add_text_message(username, message_text, is_toxic) -> void:
    var new_message = TextMessageScene.instance()
    add_child(new_message)
    new_message.set_username(username)
    new_message.set_text(message_text)
    new_message.set_is_toxic(is_toxic)

func add_image(username : String, message_text : String, meme_link : String) -> void:
    var download_task = Firebase.Storage.ref(meme_link).get_data()
    yield(download_task, "task_finished")
    print(download_task)
    var new_message = ImageMessageScene.instance()
    add_child(new_message)
    new_message.set_username(username)
    new_message.set_text(message_text)
    new_message.set_meme(meme_link)

func edit_message(message_id, new_message) -> void:
    pass
