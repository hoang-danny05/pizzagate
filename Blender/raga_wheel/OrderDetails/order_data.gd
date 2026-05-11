extends Resource
class_name OrderData
## Data that's associated with an order
## Only responsibility is to encapsulate order data
## and provide a good interface to access it. 

## the string to describe the order (order number)
@export var order_title : String 
## the boss name (ex: BUFFERFISH)
@export var dish_name : String 
## description of the boss
## planning to put this in the Special Notes section of the order
@export var description : String
## difficulty of the order
## normally on a scale of [1-5]
## may add difficulties above 5 if time permits (michellin stars) 
@export var difficulty : int

## the level that the order is associated with
## I don't think I can assert the scene inherits Level but so be it
@export_file_path("*.tscn") var target_level
 
## the thumbnail of the boss of the level
## scary factor
@export_file_path var thumbnail 


## @experimental: Not implemented yet until we implement Saves
## Returns if the current order has been completed (boss defeated)
## 
## Checks the current save to determine. 
func is_completed() -> bool:
	return false
