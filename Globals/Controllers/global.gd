extends Node

# I guess this is where we put global stuff shared across nodes
# Standard -> snake_case
# naming : [general purpose]_[specific function]

# of Input.MouseMode
@export var mouse_mode_stack : Array = []

func mouse_mode_push(mode : Input.MouseMode):
	mouse_mode_stack.append(mode)

func mouse_mode_pop_and_apply():
	var mode = mouse_mode_stack.pop_back()
	Input.mouse_mode = mode
