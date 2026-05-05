extends Node3D


func _ready() -> void:
	var interaction_controller = $InteractableComponent
	interaction_controller.onInteraction.connect(_on_interact)
	

func _on_interact() -> void:
	print("AHHH MY FACE")
	pass
