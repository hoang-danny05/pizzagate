@tool
extends GGSSetting
class_name SettingGameplayGodmode
## Changes display mode between fullscreen, borderless, and windowed.

## A setting that can handle window size. Used to set the game window to the correct size after its state changes.
#@export var size_setting: GGSSetting


func _init() -> void:
	type = TYPE_BOOL
	hint = PROPERTY_HINT_ENUM
	hint_string = "Boolean to determine if the player has God Mode activated"
	default = false
	section = "gameplay"


func apply(_god_mode: bool) -> void:
	#print("God Mode Updated to: ", god_mode)
	pass
