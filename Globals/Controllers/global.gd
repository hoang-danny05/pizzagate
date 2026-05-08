extends Node

# I guess this is where we put global stuff shared across nodes
# Standard -> snake_case
# naming : [general purpose]_[specific function]

# of Input.MouseMode
@export var mouse_mode_stack : Array = []

## Pushes the given mouse mode to a global stack of mouse modes
## 
## Useful for keeping track of different mouse modes in order to 
## return to the previous one when desired. Mostly useful for
## focus elements that override the current mouse mode, but desire
## to return to the older mouse mode when focus is exited
func mouse_mode_push(mode : Input.MouseMode):
	mouse_mode_stack.append(mode)

## bro read the function title
func mouse_mode_pop_and_apply():
	var mode = mouse_mode_stack.pop_back()
	Input.mouse_mode = mode
