extends Control
class_name SettingsMenu

@export var active : bool
@onready var animation = $AnimationPlayer


# The global settings class. 
# Literally just controls what you do when you open and close settings.
#signal settings_toggled(settings_active : bool)

func _ready() -> void:
	active = visible
	process_mode = Node.PROCESS_MODE_ALWAYS
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# yeah.
# So it's actually always active, might be tanking performance?
func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventKey and event.is_action_pressed("ui_cancel")):
		#visible = ! visible;
		active = ! active;
		#settings_toggled.emit(visible)
		
		if active:
			_activate()
		else:
			_deactivate()
			
		get_viewport().set_input_as_handled()

func _activate():
	visible = true
	get_tree().paused = true
	Global.game_controller.blur_enable()
	Global.mouse_mode_push(Input.mouse_mode)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	animation.play("flick_up")
	
	

func _deactivate():
	get_tree().paused = false
	Global.game_controller.blur_disable()
	Global.mouse_mode_pop_and_apply()
	animation.play("peace_out")
	await animation.animation_finished
	visible = false

func on_blur_click():
	if active:
		active = !active
		_deactivate()
