extends Node3D



func _on_interaction() -> void:
	if Global.save_data_load(0):
		print("loaded successfully!")
	else:
		Global.save_data_init()
		print("created new save file")
