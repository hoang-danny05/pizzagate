extends Control
class_name HUD

signal health_low
signal health_zero
signal sauce_max

var _health : float = 67
var _sauce : float = 69
var _tween : Tween

@onready var health_bar = $ColorRect/HealthBar
@onready var sauce_bar = $ColorRect/SauceBar

func _ready() -> void:
	health_bar.value = _health
	sauce_bar.value = _sauce

func _enter_tree() -> void:
	Global.current_hud = self

func _exit_tree() -> void:
	Global.current_hud = null

func _update_values() -> void:
	_tween = create_tween()
	_tween.tween_property(health_bar, "value", _health, 0.3)
	_tween.tween_property(sauce_bar, "value", _sauce, 0.3)
	

func set_health(new_health : float) -> void:
	_health = new_health
	# low health threshold
	if _health < 25:
		health_low.emit()
	elif _health < 0:
		health_zero.emit()
	_update_values()

func set_sauce(new_sauce : float) -> void:
	_sauce = new_sauce
	if _sauce >= 1:
		sauce_max.emit()
	_update_values()
