@tool
extends UiButton

func _on_pressed() -> void:
	# simply quit game
	get_tree().quit()
