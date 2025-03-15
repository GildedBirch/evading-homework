class_name LightBulb
extends Area3D


const COLORS: Array[Color] = [
	Color("#ebddc8"),
	Color("#9cae71"),
	Color("#78b1b0"),
	Color("#81a7dc"),
	Color("#c092c8"),
	Color("#da8c8e"),
]

var current_color: int = 1

@onready var omni_light_3d: OmniLight3D = %OmniLight3D


func interact() -> void:
	current_color += 1
	if current_color >= COLORS.size() - 1:
		current_color = 0
	omni_light_3d.light_color = COLORS[current_color]
