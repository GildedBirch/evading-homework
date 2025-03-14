class_name Button3D
extends Area3D


signal pressed

@export var press_depth: float = 0.025
@export var button_mesh: Node3D


func interact() -> void:
	pressed.emit()
	# Play sound
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button_mesh, "position:y", position.y - press_depth, 0.2)
	tween.tween_property(button_mesh, "position:y", position.y + press_depth, 0.2)
