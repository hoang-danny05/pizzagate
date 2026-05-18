extends Control

@export var active_element : Control

@export_file_path("*.tscn") var hub_scene_path 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_new_game_pressed() -> void:
	Global.game_controller.load_scene(hub_scene_path)


func _on_quit_pressed() -> void:
	get_tree().quit()
