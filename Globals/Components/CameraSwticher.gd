extends Node3D
class_name CameraSwitcher

@onready var blend_cam: Camera3D   = $BlendCamera
@onready var fade_layer: CanvasLayer = $CanvasLayer
@onready var fade_rect: TextureRect  = $CanvasLayer/TextureRect

var _current: Camera3D
var _adopted: Camera3D
var _tween : Tween

func _ready() -> void:
	_current = _find_current_camera()
	_configure_fade(false, 0.0)
	
	# Safety: keep BlendCam internal
	if blend_cam.is_in_group("cameras"):
		blend_cam.remove_from_group("cameras")
	blend_cam.current = false

# Remember the gameplay camera (nice for returning later).
func adopt(cam: Camera3D) -> void:
	_adopted = cam
	if cam:
		cut_to(cam)

func adopt_current() -> void:
	_adopted = _current
	if _current:
		cut_to(_current)

func cut_to(target: Camera3D) -> void:
	if not target: return
	if _current: _current.current = false
	target.current = true
	_current = target
	blend_cam.current = false

func blend_to(target: Camera3D, duration := 0.7) -> void:
	#print("global:", target.global_transform, _current.get_path())
	#print("local :", _adopted.transform, _adopted.get_path())
	#print("equality:", target == _adopted)

	if not target or target == _current: 
		return
	# Pose BlendCam at current
	blend_cam.global_position = _current.global_position
	blend_cam.fov = _current.fov
	blend_cam.near = _current.near
	blend_cam.far = _current.far
	blend_cam.rotation = _current.rotation
	blend_cam.current = true
	
	if (_tween and _tween.is_running()):
		_tween.stop()

	_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(blend_cam, "global_position", target.global_position, duration)
	_tween.parallel().tween_property(blend_cam, "fov", target.fov, duration)
	_tween.parallel().tween_property(blend_cam, "global_rotation", target.global_rotation, duration)
	await _tween.finished

	cut_to(target)

func fade_to(target: Camera3D, fade_time := 0.25, hold := 0.0) -> void:
	if not target: return
	await _fade(1.0, fade_time)
	cut_to(target)
	if hold > 0.0:
		await get_tree().create_timer(hold).timeout
	await _fade(0.0, fade_time)

func _fade(alpha: float, time: float) -> void:
	_configure_fade(true, fade_rect.modulate.a)
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(fade_rect, "modulate:a", alpha, max(0.0, time))
	await tw.finished
	if alpha <= 0.0:
		_configure_fade(false, 0.0)

func _configure_fade(visible_override: bool, a: float) -> void:
	fade_layer.visible = visible_override or a > 0.0
	fade_rect.modulate = Color(0,0,0,a)
	#fade_rect.size = get_viewport_rect().size

func _find_current_camera() -> Camera3D:
	# Prefer explicitly current cameras
	for node in get_tree().get_nodes_in_group("cameras"):
		if node is Camera3D and node.current:
			return node
	# Fallback: first Camera3D found
	for node in get_tree().get_nodes_in_group(""):
		if node is Camera3D:
			return node
	print("[WARN]: no camera found in cameras! Can't find current camera!")
	return null
