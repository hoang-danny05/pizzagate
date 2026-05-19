extends TabContainer
## controller for sound effects that the TabContainer will play




func _on_tab_changed(_tab: int) -> void:
	GGS.audio_activated.play()


func _on_tab_hovered(_tab: int) -> void:
	GGS.audio_mouse_entered.play()
