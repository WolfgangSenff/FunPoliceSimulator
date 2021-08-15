extends Control

onready var _updates_popup = $UpdatesPopup

onready var channel_list = $HSplitContainer/RoomScrollContainer/VBoxContainer
const CHANNEL_BUTTON = preload("res://scenes/ItemButton.tscn")
const CATEGORY_BUTTON = preload("res://scenes/CategoryButton.tscn")

var _db_ref

func _ready() -> void:
	Firebase.Auth.login_anonymous()
	_updates_popup.show_updates(["All new accessibility options available! MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM", "Try out the new Moderator Approval action - it's Breadtastic!", "Try the new Moderator Disapproval action!", "Morning, Jamwise Gamgees!"])
	if Firebase.Auth.auth.empty():
		Firebase.Auth.connect("login_succeeded", self, "_on_auth_succeeded", [], CONNECT_ONESHOT)
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
			category_instance.button.text = category
	else:
		print("Well crap.")

func _on_auth_succeeded(auth) -> void:
	_db_ref = Firebase.Database.get_database_reference("root/FunPo/Actions", { })
	_db_ref.connect("new_data_update", self, "_on_new_actions")
	_db_ref.connect("patch_data_update", self, "_on_update_actions")

func _on_new_actions(data) -> void:
	pass

func _on_update_actions(data) -> void:
	pass
