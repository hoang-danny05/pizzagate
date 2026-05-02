extends Node3D
class_name InteractableComponent

signal onInteraction
signal onEntered

var collision : Area3D
var label : Label3D
@export var label_text = "Default Label Text"

func _ready() -> void:
	collision = $Area3D
	collision.body_entered.connect(_on_entered)
	collision.body_exited.connect(_on_exited)
	label = $Label3D
	_deactivate()
	label.text = label_text
	pass 

func _on_entered(_node : Node3D) -> void:
	#print("Interaction Component!!")
	onEntered.emit()
	onInteraction.emit()
	_activate()
	
func _on_exited(_node : Node3D) -> void:
	label.visible = false
	_deactivate()

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("interact"):
		print("Interaction!!")
		onInteraction.emit()
	


# helper functions
func _deactivate() -> void:
	label.visible = false
	set_process(false)

func _activate() -> void:
	label.visible = true
	set_process(true)
