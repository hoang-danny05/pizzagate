extends Control
class_name SaveSlot

@onready var background = $SaveBG
@onready var label_num = $SaveBG/SaveNumber
@onready var label_name = $SaveBG/SaveName
@onready var label_date = $SaveBG/SaveDate
@onready var btn_save = $SaveBG/MarginContainer/HBoxContainer/SaveButton
@onready var btn_load = $SaveBG/MarginContainer/HBoxContainer/LoadButton

var allow_save : bool = false
var allow_load : bool = false
var slot_number : int
var save_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("oh shit")
	render()

func render():
	render_from_slot(slot_number)

func render_from_slot(slot : int) -> void:
	var save_file_path = Global.SAVE_FILE_FORMAT.format([slot])

	label_num.text = "{0}".format([slot]) 
	
	if !ResourceLoader.exists(save_file_path):
		btn_save.disabled = !allow_save
		btn_load.disabled = true
		label_name = "Empty"
		label_date.visible = false
		return
	
	save_data = load(save_file_path)
	label_name.text = "Save slot {0}".format([slot])
	label_date = FileAccess.get_modified_time(save_file_path)
	
