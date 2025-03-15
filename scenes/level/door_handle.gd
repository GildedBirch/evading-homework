class_name DoorHandle
extends Area3D


@onready var locked_label: Label = %LockedLabel


func interact() -> void:
	SignalBus.play_sound.emit(&"GameOver")
	locked_label.self_modulate.a = 1.0
	locked_label.show()
	var timer = get_tree().create_timer(3.0)
	await timer.timeout
	var tween = get_tree().create_tween()
	tween.tween_property(locked_label, "self_modulate:a", 0, 1.0)
	await tween.finished
	locked_label.hide()
