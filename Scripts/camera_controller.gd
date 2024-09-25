extends Node3D

@onready var player = $"../Player"
var base_postition = Vector3()
var base_rotation = Vector3()

func _ready():
	base_postition = position
	base_rotation = rotation
	
func _process(delta):
	position = player.position
	if Input.is_action_pressed("camera_rotation_left"):
		rotation.y += 1.0 * delta
	if Input.is_action_pressed("camera_rotation_right"):
		rotation.y -= 1.0 * delta
	if Input.is_action_pressed("camera_gimbal_up"):
		position.y -= 1.0 * delta
		rotation.x -= 0.3 * delta
	if Input.is_action_pressed("camera_gimbal_down"):
		position.y += 1.0 * delta
		rotation.x += 0.3 * delta
	if Input.is_action_just_pressed("rotate_camera"):
		rotation_degrees.y += 90
