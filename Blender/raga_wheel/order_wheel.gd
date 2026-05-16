extends Node3D

var rotation_tween : Tween
var player_cam : Camera3D
## the condition of if the UI is focused at the moment.
var active : bool 
## the condition for if the sub UI for orders are focused at the moment
var order_focused : bool = false

@onready var interaction_controller : InteractableComponent = $InteractableComponent
@onready var camera : Camera3D = $EpicCamera
@onready var pivot : Node3D = $Pivot
@onready var btn_right : Button = $right
@onready var btn_left : Button = $left
@onready var order_details : OrderDetails = $OrderDetails

@export var switcher : CameraSwitcher
@export var current_order : Order

func _ready() -> void:
	interaction_controller.onInteraction.connect(_on_interaction)
	interaction_controller.collision_area.body_exited.connect(area_left)
	
	player_cam = get_viewport().get_camera_3d() # assuming the player cam is the default active one
	
	# the default thing
	if current_order == null:
		current_order = $Pivot/Order
	
	# connect all order items (clickable) to set rotation
	for order in get_tree().get_nodes_in_group("order_items"):
		if not order is Order:
			print("[WARN]: node in order_items is not clickable! ", get_path())
			continue
		var clickable_order : Order = order
		clickable_order.focus_to_me.connect(set_focus_to)
	
	btn_left.visible = false
	btn_right.visible = false

func _on_interaction() -> void:
	# skip interaction if tween is active
	#print("interaction recieved")
	if(switcher._tween and switcher._tween.is_running()):
		return
	if (active):
		toggle_order_focus()
	else:
		_activate()

## called when the dude leaves
func area_left(_area : Node3D) -> void:
	if (active):
		_deactivate()
	## deactivate if the player is trying to be a chud
	elif (switcher._tween and switcher._tween.is_running()):
		await switcher._tween.finished
		_deactivate()
			

func _activate() -> void:
	#switcher.adopt(player_cam)
	await switcher.blend_to(camera)
	active = true
	btn_right.visible = true
	btn_left.visible = true
	#switcher.adopt_current()
	Global.mouse_mode_push(Input.mouse_mode)
	Global.player_character.movement_enabled = false
	## player goes to the side, but they start floatin a bit
	Global.player_character.global_position = $player_seat.global_position
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	


func _deactivate() -> void:
	await switcher.blend_to(player_cam) 
	active = false
	btn_right.visible = false
	btn_left.visible = false
	Global.mouse_mode_pop_and_apply()
	Global.player_character.movement_enabled = true
	order_details._deactivate()
	
	
	

func _input(event : InputEvent) -> void:
	if active:
		if event is InputEventMouseMotion:
			get_viewport().set_input_as_handled()
	
		if event is InputEventKey:
			if event.is_action_pressed("ui_left"):
				focus_prev()
			if event.is_action_pressed("ui_right"):
				focus_next()
			if event.is_action_pressed("ui_accept"):
				toggle_order_focus()
			if event.is_action_pressed("ui_cancel"):
				_deactivate()
			get_viewport().set_input_as_handled() # all other inputs are BLOCKED
	#if _inpt.is_action_pressed("debug"):
		#print(Adopted:", switcher._adopted.global_transform, switcher._adopted.get_path())
	# block all inputs when tweening
	if (switcher._tween and switcher._tween.is_running()):
		get_viewport().set_input_as_handled() # all other inputs are BLOCKED
		
	if event is InputEventKey and event.is_action_pressed("debug"):
		pass
		# put debug stuff here if you want
		#print("Active State: ", active)
		
		
########################################
# order-related methods
########################################

## select next level
func focus_next() -> void:
	set_focus_to(current_order.next_item)

## select previous level
func focus_prev() -> void:
	set_focus_to(current_order.prev_item)

## given an order, make it active.
func set_focus_to(new_clickable : Order) -> void:
	if new_clickable == null:
		print("[ERR]: new_clickable was given null!")
	_focus_to_rotation(new_clickable.rotation)
	current_order = new_clickable

## given a clickable nodes rotation, this rotates the pivot
## so that the given clickable object is visible
func _focus_to_rotation(new_rotation: Vector3) -> void:
	if rotation_tween and rotation_tween.is_running():
		rotation_tween.stop()
		
	rotation_tween = create_tween()
	rotation_tween.set_ease(Tween.EASE_OUT)
	rotation_tween.set_trans(Tween.TRANS_CUBIC)
	rotation_tween.tween_property(pivot, "rotation", new_rotation * -1, 0.5)

func toggle_order_focus() -> void:
	#print("CURRENT GUY FOCUSED")
	if (current_order.order_data):
		order_details.set_order_data(current_order.order_data)
		order_details.toggle_active()
		pass
	pass
