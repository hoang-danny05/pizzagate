extends Node3D

var player_cam : Camera3D
var camera : Camera3D
var interaction_controller : InteractableComponent
var active : bool
@onready var thief : GUI3D = $InputThief
@export var switcher : CameraSwitcher

func _ready() -> void:
	interaction_controller = $InteractableComponent
	interaction_controller.onInteraction.connect(_on_interaction)
	
	camera = $EpicCamera
	player_cam = get_viewport().get_camera_3d() # assuming the player cam is the default active one

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
	active=true
	thief.block_mouse_motion = true
	

func _deactivate() -> void:
	switcher.blend_to(player_cam) # dude i have no idea why blend doesn't work
	#switcher.cut_to(player_cam) # temp solution
	active=false
	thief.block_mouse_motion = false

func _input(_inpt : InputEvent) -> void:
	if _inpt.is_action_pressed("debug"):
		print("Adopted:", switcher._adopted.global_transform, switcher._adopted.get_path())
		
	#if _inpt.is_action_pressed("interact"):
		#_deactivate()
