extends Node3D

var camera : Camera3D

func _ready() -> void:
	var interaction_controller = $InteractableComponent
	interaction_controller.onInteraction.connect(_activate)
	
	camera = $EpicCamera
	set_process_input(false)
	

func _activate() -> void:
	camera.current = true
	set_process_input(true)

func _deactivate() -> void:
	camera.current = false
	#set_process_input(false)

func _input(_inpt : InputEvent) -> void:
	if _inpt.is_action_pressed("ui_toggle"):
		_deactivate()
	
	pass
