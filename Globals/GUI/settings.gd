extends Control

# The global settings class. 
# Literally just controls what you do when you open and close settings.
signal settings_hidden

func _ready() -> void:
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# yeah.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_toggle")):
		visible = ! visible;
		if visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			settings_hidden.emit()
