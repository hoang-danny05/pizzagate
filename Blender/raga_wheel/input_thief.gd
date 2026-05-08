extends Node3D
class_name GUI3D


@export var block_mouse_motion = false

func _input(event) -> void:
	if block_mouse_motion:
		# Only block if it is NOT the interact key
		if event is InputEventKey and Input.is_action_pressed("interact"):
			return  # Don't block E
		get_viewport().set_input_as_handled()
		
		# don't handle 
