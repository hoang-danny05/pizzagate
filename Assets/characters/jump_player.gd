extends AudioStreamPlayer3D

const jump_sounds = [
	preload("res://Assets/audio/main_character/jump1.mp3"),
	preload("res://Assets/audio/main_character/jump2.mp3"),
	preload("res://Assets/audio/main_character/jump3.mp3"),
	preload("res://Assets/audio/main_character/jump4.mp3")
]

func play_jump():
	stream = jump_sounds.pick_random()
	play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
