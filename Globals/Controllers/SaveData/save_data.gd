extends Resource
class_name SaveData
## Encapsulates the save data for a single slot
## Put all data you want save/loaded here
##
## NOT a global save file. 
## Cannot hold data that persists across save files

@export var version_number : String = "v0.1.0" 
@export var player_health : float = 100
@export var player_sauce : float = 0

func save(slot : int = 0):
	## saves to the filesystem
	## @param slot: the save slot to assign this to
	Global.save_data_persist(slot)
	
		
