class_name GameController extends Node

#defaults
@export var world3d : Node3D 
@export var gui : Control 

var current_world3D : Node3D 
var current_gui : Control 


func _ready() -> void:
	#Globals.game_controller = self
	current_world3D = world3d
	gui = current_gui

"""
new_scene: the new scene that we want in the fs
delete: if we want to delete the old scene
	removes scene from memory
keep_running: if we want to hide the old scene
	keeps data accessible, and runs it. May be the most resource intensive
	controls whether or not to keep, well, running.
else: neither keep running nor delete
	Removes the scene. Stays in memory, but no updated data.
"""
func change_world3d_scene(
	new_scene: NodePath,
	delete: bool = true, 
	keep_running: bool = false) -> void:
	if(current_world3D != null):
		if (delete):
			# DELETION
			current_world3D.queue_free()
		elif (keep_running):
			# HIDING
			current_world3D.visible = false 
		else:
			# REMOVING (pausing)
			world3d.remove_child(current_world3D)
	var new = load(new_scene).instantiate()
	print(new)
	world3d.add_child(new)
	current_world3D = new
