extends Node
class_name GameController

signal progress_changed(progress : float)
signal load_finished

# global scoped stuff
var loading_screen : PackedScene = preload("uid://ya7mu00xq5c7")
@onready var global_ui = $Settings

# tracks state of the GameController, editing will do nothing
var loaded_resource : PackedScene
@export var current_scene : Node3D
var current_scene_path : String
var progress : Array

# options
var use_multithreading = true


func _ready() -> void:
	#Globals.game_controller = self
	set_process(false) # I won't be processing until you tell me to!



func load_scene(_scene_path : String) -> void:
	_before_start_load()
	current_scene_path = _scene_path
	
	var new_load_screen : LoadingScreen = loading_screen.instantiate()
	add_child(new_load_screen)
	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_progress_finished)
	
	await new_load_screen.loading_screen_ready
	
	start_load() # hmm, we only start the load once this finishes? 
	
func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(current_scene_path, "", use_multithreading)
	if state == OK:
		set_process(true) # start the loader
	

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(current_scene_path, progress)
	progress_changed.emit(progress[0])
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(current_scene_path)
			_replace_current_scene_with(loaded_resource)
			#get_tree().change_scene_to_packed(loaded_resource) # this replaces EVERYTHING, but ideally replace Node3D
			load_finished.emit()

func _replace_current_scene_with(new_scene : PackedScene): 
	remove_child(current_scene)
	var instantiated_scene = new_scene.instantiate()
	add_child(instantiated_scene)
	current_scene = instantiated_scene
	_after_load_finish()

# to prevent the user from pausing on the load screen
func _before_start_load():
	global_ui.set_process(false)

func _after_load_finish():
	global_ui.set_process(true)



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

#func change_world3d_scene(
	#new_scene: NodePath,
	#delete: bool = true, 
	#keep_running: bool = false) -> void:
	#if(current_world3D != null):
		#if (delete):
			## DELETION
			#current_world3D.queue_free()
		#elif (keep_running):
			## HIDING
			#current_world3D.visible = false 
		#else:
			## REMOVING (pausing)
			#world3d.remove_child(current_world3D)
	#var new = load(new_scene).instantiate()
	#print(new)
	#world3d.add_child(new)
	#current_world3D = new
