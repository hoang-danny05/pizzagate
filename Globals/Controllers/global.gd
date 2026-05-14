extends Node
## everything you need global scoped.

# I guess this is where we put global stuff shared across nodes
# Standard -> snake_case
# naming : [general purpose]_[specific function]

#region Mouse mode helper functions

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

#endregion

#region Audio related helper functions

## abstraction to play a sound effect with some volume and pitch variation
func audio_play_with_variation(
	audio_player: AudioStreamPlayer,
	min_pitch: float = 1.0,
	max_pitch: float = 1.0, 
	min_volume_decibels : float = 0.0,
	max_volume_decibels : float = 0.0):
	if not audio_player.is_inside_tree():
		print("[INFO]: Can't play audio, player was removed from scene tree")
		return
	audio_player.pitch_scale = randf_range(min_pitch, max_pitch)
	audio_player.volume_db = randf_range(min_volume_decibels, max_volume_decibels)
	audio_player.play()

#endregion

@export var game_controller : GameController
@export var player_character : Armando
