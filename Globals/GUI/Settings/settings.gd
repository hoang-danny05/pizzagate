extends Control

# The global settings class. 
# Literally just controls what you do when you open and close settings.
signal settings_toggled(settings_active : bool)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# yeah.
# So it's actually always active, might be tanking performance?
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_toggle")):
		visible = ! visible;
		settings_toggled.emit(visible)
		if visible:
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().paused = false
