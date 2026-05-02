extends Node3D

var interaction_controller : InteractableComponent
@export var target_level : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup interaction controller
	interaction_controller = $InteractableComponent
	interaction_controller.onInteraction.connect(_on_interaction)
	# assert it is a Level. Otherwise, alert.
	print("hello level 2 ")
	_print_target_level_warnings()


func _on_interaction() -> void:
	print("Scene Switch!!")
	print(target_level.get_path())
	
	var controller : GameController = get_node("/root/GameController")
	controller.load_scene(target_level.get_path())
	
	#GameController.load_scene(target_level.get_path())


func _print_target_level_warnings() -> void:
	if not target_level:
		print("[WARN]: No target level specified for: ", self.get_path())
		return
		
	var target_level_script : Script = target_level.get_state().get_node_property_value(0, 0)
	
	if (not target_level_script is Script):
		print("[WARN] Target level does not inherit from Level:", self.get_path())
		print("Got: ", typeof(target_level_script))
		return
		
	#TODO: actually check class names or somthin
	#print(target_level_script.get_global_name())
	#if (not target_level_script.get_global_name() ):
		#print("[WARN] Target level inherits from unexpected class:", self.get_path())
		#print("Got: ", target_level_script.g)
		#return
