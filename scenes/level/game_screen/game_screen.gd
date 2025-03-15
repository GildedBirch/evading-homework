class_name GameScreen
extends SubViewport


const OBSTACLES: Array = [
	preload("res://scenes/level/game_screen/obstacles/obstacle_jump.tscn"),
	preload("res://scenes/level/game_screen/obstacles/obstacle_shoot.tscn"),
	]

@export var target_screen: MeshInstance3D
@export var jump_button: Button3D
@export var shoot_button: Button3D

var _game_running:bool = false

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
	if _game_running == false:
		_game_running = true
		return
		obstacle_spawn_timer.start()
	player_2d.jump()


func _shoot_button_pressed() -> void:
	player_2d.shoot()


func _on_obstacle_spawn_timer_timeout() -> void:
	obstacle_spawn_timer.wait_time = randf_range(1.0, 3.0)
	var obstacle: Obstacle = OBSTACLES.pick_random().instantiate()
	add_child(obstacle)
	obstacle.global_position = obstacle_spawn_point.global_position


func _on_game_over() -> void:
	obstacle_spawn_timer.stop()
	_game_running = false
