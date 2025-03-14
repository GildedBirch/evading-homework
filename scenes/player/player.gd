class_name Player
extends CharacterBody3D


var mouse_motion: Vector2 = Vector2.ZERO

@export var speed: float = 5.0
@export var mouse_sens: float = 0.002

@onready var camera_pivot: Node3D = %CameraPivot
@onready var right_hand: Node3D = %RightHand


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	
	var input_dir: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion = -event.relative * mouse_sens


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		hand_press()


func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -90.0, 90.0)
	mouse_motion = Vector2.ZERO


func hand_press() -> void:
	print("yee")
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(right_hand, "position:z", -0.3, 0.2)
	tween.tween_property(right_hand, "position:z", 0, 0.2)
