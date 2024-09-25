extends CharacterBody3D
var current_state = player_states.MOVE
enum player_states {MOVE, JUMP, ATTACK}

@export var speed := 4.0
@export var gravity := 16.0
@export var jump_force := 8.0

@onready var player_body = $Knight/Rig
@onready var player_anim = $Knight/AnimationPlayer
@onready var camera = $"../Camera Gimbal/Camera3D"
@onready var sword_collider = $"Knight/Rig/Skeleton3D/1H_Sword/Area3D/Sword Collider"

var angular_speed = 10
var movement
var direction

func _ready():
	sword_collider.disabled = true

func _physics_process(delta):	
	match current_state:
		player_states.MOVE:
			_move(delta)
		player_states.JUMP:
			_jump(delta)
		player_states.ATTACK:
			_attack(delta)

func _input(event):
	if Input.is_action_just_pressed("attack") and is_on_floor():
		current_state = player_states.ATTACK
	if Input.is_action_just_pressed("jump"):
		current_state = player_states.JUMP

func _move(delta):
	movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, camera.rotation.y).normalized()
	
	if direction:
		player_anim.play("Running_A")
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		player_body.rotation.y = lerp_angle(player_body.rotation.y, atan2(velocity.x, velocity.z), delta * angular_speed)
	else:
		player_anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	velocity.y -= gravity * delta
	move_and_slide()
	
func _attack(delta):
	player_anim.play("1H_Melee_Attack_Slice_Diagonal")
	await player_anim.animation_finished
	current_state = player_states.MOVE

func _jump(delta):
	velocity.y = jump_force
	#player_anim.play("Jump_Full_Short")
	#await player_anim.animation_finished
	current_state = player_states.MOVE
