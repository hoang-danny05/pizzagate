extends Node3D
class_name InteractableComponent

signal onInteraction

## the area that is valid for the interactable component. 
## Override the default by setting this
var label : Label3D
@export var collision_area : Area3D
@export var label_text = "Default Label Text"
@export var enabled : bool = true

func _ready() -> void:
	if (not collision_area):
		collision_area = $Area3D
	collision_area.body_entered.connect(_on_entered)
	collision_area.body_exited.connect(_on_exited)
	
	label = $Label3D
	_deactivate()
	label.text = label_text

func set_label_text(text : String) -> void:
	label_text = text # just in case, ya neva know
	label.text = text

func _on_entered(_node : Node3D) -> void:
	#print("Interaction Component!!")
	_activate()
	
func _on_exited(_node : Node3D) -> void:
	_deactivate()

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("interact") and enabled:
		#print("Interaction!!")
		onInteraction.emit()
	


# helper functions
func _deactivate() -> void:
	label.visible = false
	set_process(false)

func _activate() -> void:
	label.visible = true
	set_process(true)
