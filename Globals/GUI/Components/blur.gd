extends ColorRect
class_name Blur

signal blur_clicked


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			visible = false
			blur_clicked.emit()
			get_viewport().set_input_as_handled()
		#print(event)
	pass # Replace with function body.

func activate():
	visible = true

func deactivate():
	visible = false
