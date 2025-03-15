class_name RightHand
extends Area3D


@onready var hand_label: Label = %HandLabel



func interact() -> void:
	SignalBus.play_sound.emit(&"Hit")
	hand_label.self_modulate.a = 1.0
	hand_label.show()
	var timer = get_tree().create_timer(3.0)
	await timer.timeout
	var tween = get_tree().create_tween()
	tween.tween_property(hand_label, "self_modulate:a", 0, 1.0)
	await tween.finished
	hand_label.hide()
