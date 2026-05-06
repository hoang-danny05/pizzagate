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
func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.is_action_pressed("ui_toggle")):
		visible = ! visible;
		settings_toggled.emit(visible)
		if visible:
			get_tree().paused = true
			Global.mouse_mode_push(Input.mouse_mode)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().paused = false
			Global.mouse_mode_pop_and_apply()
			
