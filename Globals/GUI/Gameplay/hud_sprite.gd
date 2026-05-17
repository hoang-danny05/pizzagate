extends Sprite3D
class_name HUD_SPRITE

var active : bool = true

@onready var hud_gui = $SubViewport/Hud
@onready var animation = $AnimationPlayer

func _ready() -> void:
	pass 

func toggle_state():
	visible = !visible
	pass
