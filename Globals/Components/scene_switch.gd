extends Node3D

var interaction_controller : InteractableComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_controller = $InteractableComponent
	interaction_controller.onInteraction.connect(_on_interaction)
	pass # Replace with function body.

func _on_interaction() -> void:
	print("Scene Switch!!")
