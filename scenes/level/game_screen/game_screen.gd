class_name GameScreen
extends SubViewport


@export var target_screen: MeshInstance3D
@export var jump_button: Button3D

@onready var player_2d: Player2d = %Player2D


func _ready() -> void:
	jump_button.pressed.connect(_jump_button_pressed)
	target_screen.material_override.albedo_texture = get_texture()


func _jump_button_pressed() -> void:
	player_2d.jump()
