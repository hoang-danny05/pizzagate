@abstract
extends Node3D
class_name Level

##########################
# Level class
# 	standard elements we will keep across classes
##########################


# assume we only have one starting point
# hopefully this doesn't spiral into borderlands type shi (it probably will)
@export var start_point : Node3D
@export var player_character : CharacterBody3D

func _ready() -> void:
	player_character.position = start_point.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
