extends Control
class_name LoadMenu
## UI element with all of the fuckin 

@export var allow_saves = false
@export var allow_loads = true
var save_slot_refs : Array
@onready var save_slot_container = $MarginContainer/SaveSlots

func render_slots(offset : int = 0):
	## retrieves first 10 saves
	for i in range(10 + (offset * 10)):
		var save_scene : PackedScene = load("res://Globals/GUI/TitleScreen/LoadMenu/SaveSlot.tscn")
		var save_slot = save_scene.instantiate()
		save_slot.slot_number = i
		save_slot_refs.append(save_slot)
		save_slot_container.add_child(save_slot)
		print("aed")
		
#func render_save_slots():
	#pass

func _ready() -> void:
	render_slots()
