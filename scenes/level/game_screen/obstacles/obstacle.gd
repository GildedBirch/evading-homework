class_name  Obstacle
extends Area2D


enum ObstacleType{JUMP, SHOOT, FLY}
@export var type: ObstacleType
var speed: float = 150.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	SignalBus.game_over.connect(_on_game_over)


func _process(delta: float) -> void:
	if type == ObstacleType.FLY:
		global_position.y += (speed * 0.5) * delta
	else:
		global_position.x -= speed * delta
	if global_position.x < -50:
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	SignalBus.game_over.emit()


func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	if type == ObstacleType.SHOOT or type == ObstacleType.FLY:
		SignalBus.play_sound.emit(&"Hit")
		queue_free()


func _on_game_over() -> void:
	queue_free()
