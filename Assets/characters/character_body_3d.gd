extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6.5
const DUB_JUMP_VELOCITY = 10

@onready var camera: Camera3D = $HPivot/SpringArm3D/Camera3D
@onready var v_pivot: Node3D = $HPivot/SpringArm3D
@onready var h_pivot: Node3D = $HPivot
@onready var body = $the_chef_v2
@onready var equippedItem = $"the_chef_v2/scale metarig/Skeleton3D/BoneAttachment3D/frying_pan_FBX"

var sprint_modi = 1
var has_double_jumped: bool = false
var mouse_sens = 0.01

var godmode = false

func _ready(): 
	# if a player exists, they will hold the input hostage. 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GGS.setting_applied.connect(_on_setting_applied)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_mouse_movement(event)
		
	if Input.is_action_just_pressed("leave_game"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("equip_unequip"):
		equippedItem.visible = !equippedItem.visible
		
	if Input. is_action_pressed("move_sprint"):
		sprint_modi = 3
	else: 
		sprint_modi = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		has_double_jumped = false

	# Handle jump and double jump
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("move_jump") and !has_double_jumped:
		velocity.y = DUB_JUMP_VELOCITY
		has_double_jumped = true
	elif godmode and Input.is_action_just_pressed("move_jump"):
		velocity.y = DUB_JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (h_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * sprint_modi
		velocity.z = direction.z * SPEED * sprint_modi
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * sprint_modi)
		velocity.z = move_toward(velocity.z, 0, SPEED * sprint_modi)

	move_and_slide()
	
func handle_mouse_movement(event: InputEventMouseMotion):
	var motion: Vector2 = event.relative
	v_pivot.rotation.x -= motion.y * mouse_sens
	h_pivot.rotation.y -= motion.x * mouse_sens
		
	body.rotation.y -= motion.x * mouse_sens

# Take back control when settings are hiddenw
func _on_settings_settings_toggled(setting_active : bool) -> void:
	if (setting_active):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_setting_applied(setting : GGSSetting, value : Variant):
	# if godmode is changed
	if (is_instance_of(setting, SettingGameplayGodmode)):
		godmode = value
		if value:
			print("Armando becomes god!")
		else:
			print("Armando temporarily returns to mortal form")
