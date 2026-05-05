extends Node3D

var camera : Camera3D
var interaction_controller : InteractableComponent
@export var switcher : CameraSwitcher

func _ready() -> void:
	interaction_controller = $InteractableComponent
	interaction_controller.onInteraction.connect(_activate)
	
	camera = $EpicCamera
	set_process_input(false)
	

func _activate() -> void:
	interaction_controller.enabled=false # stop listening to interacts
	switcher.adopt_current()
	#print("Adopted:", switcher._adopted.global_transform, switcher._adopted.get_path())
	set_process_input(true)
	await switcher.blend_to(camera)
		

func _deactivate() -> void:
	#await switcher.blend_to(switcher._adopted) # dude i have no idea why blend doesn't work
	switcher.cut_to(switcher._adopted) # temp solution
	wait(2)
	print("re-enabled")
	interaction_controller.enabled = true
	set_process_input(false)
	pass

func _input(_inpt : InputEvent) -> void:
	if _inpt.is_action_pressed("debug"):
		print("Adopted:", switcher._adopted.global_transform, switcher._adopted.get_path())
		
	if _inpt.is_action_pressed("interact"):
		_deactivate()

func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
