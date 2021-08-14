extends Popup

# Use this when you want to display a series of updates. It will format the strings appropriately.
# Can use rich text.

const UpdateLabelScene = preload("res://scenes/UpdateLabel.tscn")

onready var _container = $ScrollContainer/VBoxContainer
onready var _needs_update_rect = $CanvasLayer/NeedsUpdateRect
onready var _anim = $CanvasLayer/AnimationPlayer

func show_updates(updates : Array) -> void:
    popup_centered_ratio(0.75)

    for idx in _container.get_children():
        _container.remove_child(idx)

    yield(get_tree(), "idle_frame")

    for update in updates:
        var label = UpdateLabelScene.instance()
        _container.add_child(label)
        yield(label.set_update_text(update), "completed")
        yield(get_tree().create_timer(0.5), "timeout")
