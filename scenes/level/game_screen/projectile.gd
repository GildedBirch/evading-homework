class_name Projectile
extends Area2D


var speed: float = 1.0


func _process(delta: float) -> void:
	global_position.x += speed
