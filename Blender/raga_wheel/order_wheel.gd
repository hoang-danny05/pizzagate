extends Node3D

var current_tween : Tween
var player_cam : Camera3D
var active : bool ## the condition of if the boi is on or not

@onready var interaction_controller : InteractableComponent = $InteractableComponent
@onready var camera : Camera3D = $EpicCamera
@onready var thief : GUI3D = $InputThief
@onready var pivot : Node3D = $Pivot

@export var switcher : CameraSwitcher
@export var current_order : Clickable

func _ready() -> void:
	interaction_controller.onInteraction.connect(_on_interaction)
	
	player_cam = get_viewport().get_camera_3d() # assuming the player cam is the default active one
	
	if current_order == null:
		current_order = $Pivot/Clickable
	
	# connect all order items (clickable) to set rotation
	for order in get_tree().get_nodes_in_group("order_items"):
		if not order is Clickable:
			print("[WARN]: node in order_items is not clickable! ", get_path())
			continue
		var clickable_order : Clickable = order
		clickable_order.focus_to_me.connect(set_focus_to)

func _on_interaction() -> void:
	print(active)
	if (active):
		_deactivate()
	else:
		_activate()
	

func _activate() -> void:
	#switcher.adopt(player_cam)
	switcher.adopt_current()
	switcher.blend_to(camera)
	Global.mouse_mode_push(Input.mouse_mode)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	active=true
	thief.block_mouse_motion = true
	

func _deactivate() -> void:
	switcher.blend_to(player_cam) 
	Global.mouse_mode_pop_and_apply()
	active=false
	thief.block_mouse_motion = false

#func _input("_inpt : InputEvent) -> void:
	#if _inpt.is_action_pressed("debug"):
		#print(Adopted:", switcher._adopted.global_transform, switcher._adopted.get_path())
		

func set_focus_to(new_clickable : Clickable) -> void:
	_focus_to_rotation(new_clickable.rotation)

## given a clickable nodes rotation, this rotates the pivot
## so that the given clickable object is visible
func _focus_to_rotation(new_rotation: Vector3) -> void:
	pivot.rotation = new_rotation * -1
