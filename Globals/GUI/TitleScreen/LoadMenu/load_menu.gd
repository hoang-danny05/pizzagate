extends Control
class_name LoadMenu
## UI element with all of the fuckin 



func retrieve_save_data(offset : int = 0):
	## retrieves first 10 saves
	for i in range(10):
		var file_name = Global.SAVE_FILE_FORMAT.format([i])
		if ResourceLoader.exists(file_name):
			print(file_name, " exists!")
		else:
			print(file_name, " does not exist!")

func render_save_slots():
	pass

func _ready() -> void:
	retrieve_save_data(0)
