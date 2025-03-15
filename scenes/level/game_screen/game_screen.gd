class_name GameScreen
extends SubViewport


@export var target_screen: MeshInstance3D
@export var jump_button: Button3D
@export var shoot_button: Button3D

const OBSTACLES: Array = [
	preload("res://scenes/level/game_screen/obstacles/obstacle_jump.tscn"),
	preload("res://scenes/level/game_screen/obstacles/obstacle_shoot.tscn"),
	]

@onready var player_2d: Player2d = %Player2D
@onready var obstacle_spawn_point: Marker2D = %ObstacleSpawnPoint
@onready var obstacle_spawn_timer: Timer = %ObstacleSpawnTimer


func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)
	jump_button.pressed.connect(_jump_button_pressed)
	shoot_button.pressed.connect(_shoot_button_pressed)
	obstacle_spawn_timer.timeout.connect(_on_obstacle_spawn_timer_timeout)
	target_screen.material_override.albedo_texture = get_texture()


func _jump_button_pressed() -> void:
	player_2d.jump()


func _shoot_button_pressed() -> void:
	player_2d.shoot()


func _on_obstacle_spawn_timer_timeout() -> void:
	var obstacle: Obstacle = OBSTACLES.pick_random().instantiate()
	add_child(obstacle)
	obstacle.global_position = obstacle_spawn_point.global_position


func _on_game_over() -> void:
	obstacle_spawn_timer.stop()
