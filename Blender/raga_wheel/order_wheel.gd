extends Node3D

var camera : Camera3D
@export var switcher : CameraSwitcher

func _ready() -> void:
	var interaction_controller = $InteractableComponent
	interaction_controller.onInteraction.connect(_activate)
	
	camera = $EpicCamera
	set_process_input(false)
	

func _activate() -> void:
	set_process_input(true)
	await switcher.blend_to(camera)

func _deactivate() -> void:
	pass
	#switcher.blend_to()
	#set_process_input(false)

func _input(_inpt : InputEvent) -> void:
	if _inpt.is_action_pressed("ui_toggle") or _inpt.is_action_pressed("interact"):
		_deactivate()
	
	pass
