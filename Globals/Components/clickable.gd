extends Node3D

#signal mouse_entered
@onready var mesh : CSGBox3D = $CSGBox3D
@onready var collision : StaticBody3D = $StaticBody3D
@export var focus_material : Material
var init_material : Material

func _ready() -> void:
	collision.mouse_entered.connect(_on_hovered)
	collision.mouse_exited.connect(_on_exited)
	init_material = mesh.material
	pass

#func _input(event: InputEvent) -> void:
	#pass

func _on_hovered() -> void:
	mesh.material = focus_material
	print("hovered")

func _on_exited() -> void:
	mesh.material = init_material
	print("exited")


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	print("input?")
	print(event)
	get_viewport().set_input_as_handled()
	pass # Replace with function body.
