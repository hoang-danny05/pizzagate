extends CanvasLayer
class_name LoadingScreen

signal loading_screen_ready

@export var animation_player : AnimationPlayer 

# called when the loading screen is first instantiated
func _ready() -> void:
	await animation_player.animation_finished
	loading_screen_ready.emit()	

func _on_progress_changed(_progress : float) -> void:
	# do something here
	pass
	
func _on_progress_finished() -> void:
	# we can make a separate transition on finish
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
