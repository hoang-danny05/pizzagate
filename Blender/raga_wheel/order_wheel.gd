extends Node3D

var current_tween : Tween
var player_cam : Camera3D
var active : bool ## the condition of if the boi is on or not

@onready var interaction_controller : InteractableComponent = $InteractableComponent
@onready var camera : Camera3D = $EpicCamera
@onready var pivot : Node3D = $Pivot
@onready var btn_right : Button = $right
@onready var btn_left : Button = $left


@export var switcher : CameraSwitcher
@export var current_order : Clickable

func _ready() -> void:
	interaction_controller.onInteraction.connect(_on_interaction)
	
	player_cam = get_viewport().get_camera_3d() # assuming the player cam is the default active one
	
	# the default thing
	if current_order == null:
		current_order = $Pivot/Clickable
	
	# connect all order items (clickable) to set rotation
	for order in get_tree().get_nodes_in_group("order_items"):
		if not order is Clickable:
			print("[WARN]: node in order_items is not clickable! ", get_path())
			continue
		var clickable_order : Clickable = order
		clickable_order.focus_to_me.connect(set_focus_to)
	
	btn_left.visible = false
	btn_right.visible = false

func _on_interaction() -> void:
	# skip interaction if tween is active
	if(switcher._tween and switcher._tween.is_running()):
		return
	if (active):
		_deactivate()
	else:
		_activate()
	

func _activate() -> void:
	#switcher.adopt(player_cam)
	active = true
	btn_right.visible = true
	btn_left.visible = true
	#switcher.adopt_current()
	Global.mouse_mode_push(Input.mouse_mode)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	switcher.blend_to(camera)
	
	

func _deactivate() -> void:
	active = false
	btn_right.visible = false
	btn_left.visible = false
	Global.mouse_mode_pop_and_apply()
	switcher.blend_to(player_cam) 
	
	
	

func _input(event : InputEvent) -> void:
	if active:
		if event is InputEventMouseMotion:
			get_viewport().set_input_as_handled()
		#if event is InputEventKey
	
	#if _inpt.is_action_pressed("debug"):
		#print(Adopted:", switcher._adopted.global_transform, switcher._adopted.get_path())
		

func focus_next() -> void:
	set_focus_to(current_order.next_item)

func focus_prev() -> void:
	set_focus_to(current_order.prev_item)

func set_focus_to(new_clickable : Clickable) -> void:
	if new_clickable == null:
		print("[ERR]: new_clickable was given null!")
	_focus_to_rotation(new_clickable.rotation)
	current_order = new_clickable

## given a clickable nodes rotation, this rotates the pivot
## so that the given clickable object is visible
func _focus_to_rotation(new_rotation: Vector3) -> void:
	if current_tween and current_tween.is_running():
		current_tween.stop()
		
	current_tween = create_tween()
	current_tween.set_ease(Tween.EASE_OUT)
	current_tween.set_trans(Tween.TRANS_CUBIC)
	current_tween.tween_property(pivot, "rotation", new_rotation * -1, 0.5)

	#pivot.rotation = new_rotation * -1
