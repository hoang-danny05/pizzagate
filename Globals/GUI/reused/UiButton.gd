@tool
@abstract
extends Button
class_name UiButton



func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_on_focus_entered)

func _on_focus_entered() -> void:
	GGS.audio_focus_entered.play()

func _on_mouse_entered() -> void:
	GGS.audio_mouse_entered.play()

func _on_pressed() -> void:
	GGS.audio_activated.play()
