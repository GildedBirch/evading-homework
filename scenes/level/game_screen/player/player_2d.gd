class_name Player2d
extends CharacterBody2D


const JUMP_VELOCITY = -400.0
const PROJECTILE = preload("res://scenes/level/game_screen/player/projectile.tscn")

var can_shoot: bool = true

@onready var bullet_cooldown_timer: Timer = %BulletCooldownTimer


func _ready() -> void:
	bullet_cooldown_timer.timeout.connect(_on_bullet_cooldown_timer_timeout)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY


func shoot() -> void:
	if not can_shoot:
		return

	can_shoot = false
	var projectile: Projectile = PROJECTILE.instantiate()
	add_child(projectile)
	projectile.global_position = global_position - Vector2(0, 20)
	bullet_cooldown_timer.start()


func _on_bullet_cooldown_timer_timeout() -> void:
	can_shoot = true
