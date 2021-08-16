class_name ItemsContainer
extends ScrollContainer

onready var _items = $VBoxContainer

const ItemButtonScene = preload("res://scenes/ItemButton.tscn")

func add_new_item(item_name : String, can_press : bool) -> void: # decide if we need a room type on this, for voice rooms?

    pass
