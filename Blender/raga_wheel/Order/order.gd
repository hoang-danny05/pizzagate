extends Clickable
class_name Order

## specifically for orders, order data is 
@export var order_data : OrderData

func _ready() -> void:
	mesh = $CSGBox3D
	collision = $StaticBody3D
	super._ready()
