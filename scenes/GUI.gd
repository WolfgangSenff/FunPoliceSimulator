extends Control

onready var _updates_popup = $UpdatesPopup

onready var channel_list = $HSplitContainer/RoomScrollContainer/VBoxContainer
onready var _message_edit_text = $HSplitContainer/MarginContainer/VSplitContainer/HSplitContainer/MarginContainer/MarginContainer/EditText
onready var _message_container_box = $HSplitContainer/MarginContainer/VSplitContainer/MessageScrollContainer
onready var _add_meme_popup = $AddMemePopup

const CHANNEL_BUTTON = preload("res://scenes/ItemButton.tscn")
const CATEGORY_BUTTON = preload("res://scenes/CategoryButton.tscn")
const MessageContainerScene = preload("res://scenes/MessageContainer.tscn")
const DefaultChannel = "general"

var _db_ref

var _current_multiplayer_action_list = []
var _current_channel_items = { }
var _selected_channel = ""

var _current_message_is_toxic = false

func _ready() -> void:
    _updates_popup.show_updates(["All new accessibility options available! MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM", "Try out the new Moderator Approval action - it's Breadtastic!", "Try the new Moderator Disapproval action!", "Morning, Jamwise Gamgees!", "Try our new MEMES channel! You can submit your real memes to it and everyone will see them. IT IS MODERATED!"])
    if Firebase.Auth.auth.empty():
        Firebase.Auth.connect("login_succeeded", self, "_on_auth_succeeded", [], CONNECT_ONESHOT)
        Firebase.Auth.connect("signup_succeeded", self, "_on_auth_succeeded", [], CONNECT_ONESHOT)

        Firebase.Auth.connect("login_failed", self, "_on_auth_succeeded", [], CONNECT_ONESHOT)
        Firebase.Auth.login_anonymous()
    else:
        _on_auth_succeeded(null)

    var file = File.new()
    # Open the default channels for the server, based on the GWJ structure with a few renamed channels
    if !file.open("res://data/default_channels.tres", file.READ):
        # Get the contents as a dictionary
        var channels : Dictionary = JSON.parse(file.get_as_text()).result
        file.close()
        for category in channels.keys():
            # Instance a Category button (To emulate that Discord Feel
            var category_instance = CATEGORY_BUTTON.instance()
            channel_list.add_child(category_instance)

            # Go through all the channels in this category
            for channel in channels[category]:
                # Create a channel
                var channel_instance : Button = CHANNEL_BUTTON.instance()
                channel_instance.text = channel
                category_instance.channel_list.add_child(channel_instance)
                var message_container = MessageContainerScene.instance()
                _current_channel_items[channel] = message_container
                _message_container_box.add_child(message_container)
                message_container.hide()
                channel_instance.connect("pressed", self, "_on_channel_selected", [channel])
                if channel == DefaultChannel:
                    channel_instance.pressed = true
            category_instance.button.text = category

        _selected_channel = DefaultChannel
        _current_channel_items[_selected_channel].show()
    else:
        print("Well, crap.")

func _on_channel_selected(channel) -> void:
    _current_channel_items[_selected_channel].hide()
    _selected_channel = channel
    _current_channel_items[_selected_channel].show()

func _on_auth_succeeded(auth) -> void:
    _db_ref = Firebase.Database.get_database_reference("root/FunPo/Actions", { FirebaseDatabaseReference.LIMIT_TO_LAST : "10" })
    _db_ref.connect("new_data_update", self, "_on_new_actions")
    _db_ref.connect("patch_data_update", self, "_on_update_actions")

func _on_new_actions(data) -> void:
    if data.data.has("channel"):
        var channel = _current_channel_items[data.data.channel]
        _current_channel_items[data.data.channel].add_message_from_firebase(data)

func _on_update_actions(data) -> void:
    pass

func _on_SubmitButton_pressed() -> void:
    if _message_edit_text.text and _message_edit_text.text != "":
        if _message_edit_text.text.ends_with("\n"):
            _message_edit_text.text = _message_edit_text.text.rstrip("\n")
        _db_ref.push({
            "message_text" : _message_edit_text.text,
            "channel" : _selected_channel,
            "username" : Globals.current_user,
            "is_toxic" : _current_message_is_toxic
           })
        _message_edit_text.text = ""

func _on_AddMemeButton_pressed() -> void:
    _add_meme_popup.popup_centered_ratio(.8)


func _on_EditText_gui_input(event: InputEvent) -> void:
    if event is InputEventKey and event.is_action_pressed("ui_enter"):
        _on_SubmitButton_pressed()


func _on_AddMemePopup_file_selected(path: String) -> void:
    var filename = path.get_file()
    var upload_task = Firebase.Storage.ref("FunPo/upload/" + filename).put_file(path)
    yield(upload_task, "task_finished")
    _db_ref.push({
        "message_text" : "New meme from " + Globals.current_user,
        "channel" : _selected_channel,
        "username" : Globals.current_user,
        "is_toxic" : false,
        "meme_link" : upload_task.data.name
       })
