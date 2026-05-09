extends Node3D
class_name Clickable

signal focus_to_me(Clickable)

#signal mouse_entered
@onready var mesh : CSGBox3D = $CSGBox3D
@onready var collision : StaticBody3D = $StaticBody3D
@export var focus_material : Material
@export var next_item : Clickable ## like a double linked list, next
@export var prev_item : Clickable ## like a double linked list, prev
var init_material : Material
var currently_hovered : bool = false
var button_down : bool = false


func _ready() -> void:
	collision.mouse_entered.connect(_on_hovered)
	collision.mouse_exited.connect(_on_exited)
	init_material = mesh.material
	
	## clickable warning messages
	if (next_item == null):
		print("[WARN]: Clickable next_node should be set for ", get_path())
	if (next_item == self):
		print("[WARN]: Clickable points to itself as next obect ", get_path())
	if (prev_item == null):
		print("[WARN]: Clickable prev_node should be set for ", get_path())
	if (prev_item == self):
		print("[WARN]: Clickable points to itself as prev obect ", get_path())
	pass

func _input(event: InputEvent) -> void:
	if (currently_hovered and event is InputEventMouseButton):
		print("[input] EVENT RECIEVED!!!!")
		#print(event)
		focus_to_me.emit(self)
		
	if (event is InputEventKey and event.is_action_pressed("debug")):
		if currently_hovered:
			pass
		


func _on_hovered() -> void:
	mesh.material = focus_material
	currently_hovered = true
	#print("hovered")

func _on_exited() -> void:
	mesh.material = init_material
	currently_hovered = false
	#print("exited")


#func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	#print(_camera, _event_position, _normal, _shape_idx)
	#if (event is InputEventMouseButton):
		#print("[signal] BUTTON PRESSED!!!!")
		#pass
	#get_viewport().set_input_as_handled()
	#pass # Replace with function body.
