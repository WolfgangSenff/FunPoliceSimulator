extends Control

onready var _anim = $AnimationPlayer
onready var channel_list = $SubButtonContainer
onready var button = $Button

var open : bool = true
var states : Array

func _ready():
	states = [load("res://assets/CategoryChannelClosed.png"), load("res://assets/CategoryChannelOpen.png")]

func _on_Button_button_up():
	open = !open
	button.icon = states[int(open)]
	channel_list.visible = open


func _on_Button_mouse_entered():
	_anim.play("Highlight")


func _on_Button_mouse_exited():
	_anim.play_backwards("Highlight")
