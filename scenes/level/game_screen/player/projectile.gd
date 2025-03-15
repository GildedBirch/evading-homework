class_name Projectile
extends Area2D


enum MoveDirection{FORWARD, UP}
var direction: MoveDirection = MoveDirection.FORWARD
var speed: float = 150.0


func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)


func _process(delta: float) -> void:
	if direction == MoveDirection.UP:
		global_position.y -= speed * delta
	else:
		global_position.x += speed * delta
	if global_position.x > 600 or global_position.y < 0:
		queue_free()


func _on_game_over() -> void:
	queue_free()
