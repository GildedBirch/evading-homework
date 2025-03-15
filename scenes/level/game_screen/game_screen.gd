class_name GameScreen
extends SubViewport


const OBSTACLES: Array = [
	preload("res://scenes/level/game_screen/obstacles/obstacle_jump.tscn"),
	preload("res://scenes/level/game_screen/obstacles/obstacle_shoot.tscn"),
	]

@export var target_screen: MeshInstance3D
@export var jump_button: Button3D
@export var shoot_button: Button3D
@export var shoot_up_button: Button3D

var _game_running:bool = false
var score: int = 0
var top_score: int = 0
var speed_multiplier: float = 0

@onready var player_2d: Player2d = %Player2D
@onready var obstacle_spawn_point: Marker2D = %ObstacleSpawnPoint
@onready var obstacle_spawn_timer: Timer = %ObstacleSpawnTimer
@onready var score_label: Label = %ScoreLabel
@onready var start_game_label: Label = %StartGameLabel
@onready var score_timer: Timer = %ScoreTimer


func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)
	jump_button.pressed.connect(_jump_button_pressed)
	shoot_button.pressed.connect(_shoot_button_pressed)
	shoot_up_button.pressed.connect(_shoot_up_button_pressed)
	obstacle_spawn_timer.timeout.connect(_on_obstacle_spawn_timer_timeout)
	score_timer.timeout.connect(_on_score_timer_timeout)

	target_screen.material_override.albedo_texture = get_texture()


func _jump_button_pressed() -> void:
	if _game_running == false:
		_start_game()
		return
	player_2d.jump()


func _shoot_button_pressed() -> void:
	if _game_running == false:
		_start_game()
		return
	player_2d.shoot(Projectile.MoveDirection.FORWARD)


func _shoot_up_button_pressed() -> void:
	if _game_running == false:
		_start_game()
		return
	player_2d.shoot(Projectile.MoveDirection.UP)


func _start_game() -> void:
	_game_running = true
	start_game_label.hide()
	obstacle_spawn_timer.start()
	score_timer.start()


func _on_obstacle_spawn_timer_timeout() -> void:
	obstacle_spawn_timer.wait_time = randf_range(1.0 - speed_multiplier, 3.0 - speed_multiplier)
	var obstacle: Obstacle = OBSTACLES.pick_random().instantiate()
	add_child(obstacle)
	obstacle.global_position = obstacle_spawn_point.global_position


func _on_score_timer_timeout() -> void:
	score += 1
	score_label.text = "%03d" % score
	speed_multiplier = (score / 25) * 0.05


func _on_game_over() -> void:
	obstacle_spawn_timer.stop()
	score_timer.stop()
	_game_running = false
	if score > top_score:
		top_score = score
	score = 0
	start_game_label.show()
