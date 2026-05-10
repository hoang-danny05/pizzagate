extends Control
class_name OrderDetails
## The UI elemeent to display order information

var active : bool = false
var order_data : OrderData

@onready var focus_audio : AudioStreamPlayer = $Audio/FocusPaper

func _ready() -> void:
	_deactivate()

func toggle_active():
	if active:
		_deactivate()
	else:
		_activate()

func _activate():
	if (not order_data):
		print("[ERR]: order_data was not set before displaying!")
		return
	focus_audio.play()
	active = true
	visible = true

func _deactivate():
	active = false
	visible = false

func set_order_data(new_order : OrderData):
	if (new_order != order_data):
		if (active):
			focus_audio.play()
			# Do the transition to different orders!
			pass
	order_data = new_order
