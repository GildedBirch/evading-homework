class_name Level
extends Node


@export var quit_button: Button3D
@export var volume_up_button: Button3D
@export var volume_down_button: Button3D
var volume_db: float = 0.0


func _ready() -> void:
	quit_button.pressed.connect(_quit_button_pressed)
	volume_up_button.pressed.connect(_volume_up_button_pressed)
	volume_down_button.pressed.connect(_volume_down_button_pressed)


func _quit_button_pressed() -> void:
	get_tree().quit()


func _volume_up_button_pressed() -> void:
	volume_db = min(20, volume_db + 1)
	AudioServer.set_bus_volume_db(0, volume_db)
	SignalBus.play_sound.emit(&"Hit")


func _volume_down_button_pressed() -> void:
	volume_db = max(-20, volume_db - 1)
	AudioServer.set_bus_volume_db(0, volume_db)
	SignalBus.play_sound.emit(&"Hit")
