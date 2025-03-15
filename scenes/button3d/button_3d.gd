class_name Button3D
extends Area3D


signal pressed

@export var press_depth: float = 0.05
@export var button_mesh: Node3D
var button_mesh_pos: Vector3


func _ready() -> void:
	if button_mesh:
		button_mesh_pos = button_mesh.position


func interact() -> void:
	pressed.emit()
	# Play sound
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button_mesh, "position:y", button_mesh_pos.y - press_depth, 0.2)
	tween.tween_property(button_mesh, "position:y", button_mesh_pos.y, 0.2)
