extends Button

onready var _anim = $AnimationPlayer

const Group = preload("res://assets/resources/RoomButtonGroup.tres")

func _ready() -> void:
    group = Group

func _on_ItemButton_mouse_entered() -> void:
    _anim.play("Highlight")

func _on_ItemButton_mouse_exited() -> void:
    _anim.play_backwards("Highlight")
