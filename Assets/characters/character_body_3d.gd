extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6.5
const DUB_JUMP_VELOCITY = 10
var has_double_jumped: bool = false
const MOUSE_SENS = 0.01

@onready var camera: Camera3D
@onready var pivot: Node3D = $Pivot
@onready var body = $the_chef_v2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion: Vector2 = event.screen_relative
		
		var ymotion: float = motion.y
		var xmotion: float = motion.x
		
		pivot.rotation.x +=ymotion * MOUSE_SENS
		pivot.rotation.y -=xmotion * MOUSE_SENS
		
		body.rotation.y -=xmotion * MOUSE_SENS
		
	if Input.is_action_just_pressed("leave_game"):
		get_tree().quit()
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		has_double_jumped = false

	# Handle jump.
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("move_jump") and !has_double_jumped:
		velocity.y = DUB_JUMP_VELOCITY
		has_double_jumped = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
