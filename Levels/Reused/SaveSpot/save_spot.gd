extends Node3D



func _on_interactable_component_on_interaction() -> void:
	if Global.save_data:
		print("saving save data!")
		Global.save_data_persist(0)
	else:
		print("No data to save!")
