extends Control
class_name OrderDetails
## The UI elemeent to display order information

var active : bool = false
var order_data : OrderData
var tween : Tween

@onready var focus_audio : AudioStreamPlayer = $Audio/FocusPaper
@onready var unfocus_audio : AudioStreamPlayer = $Audio/UnfocusPaper
@onready var blur = $Blur

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
	Global.audio_play_with_variation(focus_audio, 0.9, 1.1)
	blur.activate()
	print(blur.position)
	
	active = true
	visible = true

func _deactivate():
	# only play if I was active
	if active:
		Global.audio_play_with_variation(unfocus_audio, 0.4, 0.6)
	#blur.deactivate()
	active = false
	visible = false

## using the current order data, it is rendered
func render_order_data():
	$OrderTitle.text = order_data.order_title
	$DishName.text = order_data.dish_name
	$SpecialNotesContent.text = order_data.description
	#difficlty
	#image
	var img = load(order_data.thumbnail)
	$ImageContainer/TextureRect.texture = img
	pass

func set_order_data(new_order : OrderData):
	if (new_order != order_data):
		if (active):
			focus_audio.play()
			# Do the transition to different orders!
			pass
	order_data = new_order
	render_order_data()


func _on_start_button_pressed() -> void:
	if (order_data and order_data.target_level):
		Global.game_controller.load_scene(order_data.target_level)

func _on_background_pressed() -> void:
	if active:
		_deactivate()
