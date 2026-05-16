extends Node
class_name GameController
## class responsible for switching scenes
## root of everything, always in scene tree

signal progress_changed(progress : float)
signal load_finished

# global scoped stuff
var loading_screen : PackedScene = preload("uid://ya7mu00xq5c7")
@onready var settings_menu : SettingsMenu = $Settings
@onready var blur = $"blurry face"
@onready var impact = $"impact"
@onready var impact_timer = $"impact/timer"

# tracks state of the GameController, editing will do nothing
var loaded_resource : PackedScene
@export var current_scene : Node3D
var current_scene_path : String
var progress : Array

# options
var use_multithreading = true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	current_scene.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	Global.game_controller = self
	set_process(false) # I won't be processing until you tell me to!
	
	# kind of an ugly pattern but we ball
	blur_queue_flush()
	#blur_clicked.connect(settings_menu.on_blur_click)



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
	settings_menu.set_process(false)

func _after_load_finish():
	settings_menu.set_process(true)
	current_scene.process_mode = Node.PROCESS_MODE_PAUSABLE



"""
new_scene: the new scene that we want in the fs
delete: if we want to delete the old scene
	removes scene from memory
keep_running: if we want to hide the old scene
	keeps data accessible, and runs it. May be the most resource intensive
	controls whether or not to keep,visible well, running.
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
	
	
	## ok what if i made the whole screen blur with a canvas item

#region blur
signal blur_clicked

## adds all items in the blur queue
func blur_queue_flush():
	while Global.game_controller_blur_queue:
		var item = Global.game_controller_blur_queue.pop_back()
		if item is Callable:
			blur_clicked.connect(item)
		else:
			print("[ERR]: callable not assigned to queue!")
	
	

func blur_enable():
	## makes the blur component visible
	## readable interface because why not
	blur.visible = true

func blur_disable():
	blur.visible = false

func _on_blur_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			blur.visible = false
			blur_clicked.emit()
			get_viewport().set_input_as_handled()
		#print(event)
	pass # Replace with function body.

#endregion

#region impact
func impact_display(duration : float = 0.1):
	impact_timer.start(duration)
	impact.visible = true

func _on_impact_finish():
	impact.visible = false
#endregion
