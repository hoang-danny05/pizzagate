extends Clickable
class_name Order

## specifically for orders, order data is 
@export var order_data : OrderData
@onready var order_sprite = $Sprite3D

func _ready() -> void:
	mesh = $CSGBox3D
	collision = $StaticBody3D
	super._ready()
	if (order_data):
		_render_data()

func _render_data():
	if (order_data.thumbnail):
		order_sprite.texture = load(order_data.thumbnail)
