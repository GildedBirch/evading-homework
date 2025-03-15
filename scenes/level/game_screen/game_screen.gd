class_name GameScreen
extends SubViewport


const GROUND_OBSTACLES: Array = [
	preload("res://scenes/level/game_screen/obstacles/obstacle_jump.tscn"),
	preload("res://scenes/level/game_screen/obstacles/obstacle_shoot.tscn"),
	]
const OBSTACLE_FLY = preload("res://scenes/level/game_screen/obstacles/obstacle_fly.tscn")
const MUSIC: Array = [
	preload("res://assets/sounds/music/Three Red Hearts - Deep Blue.ogg"),
	preload("res://assets/sounds/music/Three Red Hearts - Box Jump.ogg"),
	preload("res://assets/sounds/music/Three Red Hearts - Out of Time.ogg"),
	]
const SOUNDS: Dictionary = {
	&"GameOver": preload("res://assets/sounds/effects/Game Over.wav"),
	&"Jump": preload("res://assets/sounds/effects/Retro Jump Classic 08.wav"),
	&"Shoot": preload("res://assets/sounds/effects/Retro Weapon Gun LoFi 03.wav"),
	&"Hit": preload("res://assets/sounds/effects/Retro Explosion Short 15.wav"),
}

@export var target_screen: MeshInstance3D
@export var jump_button: Button3D
@export var shoot_button: Button3D
@export var shoot_up_button: Button3D
@export var music_player: AudioStreamPlayer3D
@export var effect_player: AudioStreamPlayer3D

var _game_running:bool = false
var score: int = 0
var top_score: int = 0
var speed_multiplier: float = 0

@onready var player_2d: Player2d = %Player2D
@onready var obstacle_spawn_point: Marker2D = %ObstacleSpawnPoint
@onready var fly_spawn_point: Marker2D = %FlySpawnPoint
@onready var obstacle_spawn_timer: Timer = %ObstacleSpawnTimer
@onready var score_label: Label = %ScoreLabel
@onready var top_score_label: Label = %TopScoreLabel
@onready var start_game_label: Label = %StartGameLabel
@onready var score_timer: Timer = %ScoreTimer


func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.play_sound.connect(_on_play_sound)
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
	_play_music(true, MUSIC[0])


func _on_obstacle_spawn_timer_timeout() -> void:
	obstacle_spawn_timer.wait_time = randf_range(1.0 - speed_multiplier, 3.0 - speed_multiplier)
	_spawn_obstacle(GROUND_OBSTACLES.pick_random(), obstacle_spawn_point.global_position)
	if randf() > 1.0 - speed_multiplier:
		_spawn_obstacle(OBSTACLE_FLY, fly_spawn_point.global_position)


func _spawn_obstacle(obstacle: PackedScene, pos: Vector2) -> void:
	var new_obstacle: Obstacle = obstacle.instantiate()
	add_child(new_obstacle)
	new_obstacle.global_position = pos


func _on_score_timer_timeout() -> void:
	score += 1
	score_label.text = "%03d" % score
	@warning_ignore("integer_division")
	speed_multiplier = min(0.5, (score / 25) * 0.05)
	if score == 100:
		_play_music(true, MUSIC[1])
	elif score == 200:
		_play_music(true, MUSIC[2])


func _on_game_over() -> void:
	_on_play_sound(&"GameOver")
	obstacle_spawn_timer.stop()
	score_timer.stop()
	_game_running = false
	if score > top_score:
		top_score = score
		top_score_label.text = "TOP: %03d" % top_score
	score = 0
	start_game_label.show()
	_play_music(false)


func _play_music(play: bool = true, music: AudioStream = null) -> void:
	if play:
		music_player.stream = music
		music_player.play(0.0)
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(music_player, "volume_db", -30, 2.0)
	else:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(music_player, "volume_db", -80, 2.0)
		await tween.finished
		music_player.stop()


func _on_play_sound(id: StringName) -> void:
	effect_player.stream = SOUNDS[id]
	effect_player.play(0.0)
