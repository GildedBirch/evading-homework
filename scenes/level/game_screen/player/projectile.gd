class_name Projectile
extends Area2D


var speed: float = 1.0


func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)


func _process(_delta: float) -> void:
	global_position.x += speed


func _on_game_over() -> void:
	queue_free()
