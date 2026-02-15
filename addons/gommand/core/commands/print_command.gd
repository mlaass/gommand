class_name PrintCommand
extends Command

var _message: String = ""


func _init(message: String) -> void:
	_message = message
	super._init([], true)


func initialize() -> void:
	print(_message)


func physics_execute(delta_time: float) -> void:
	pass


func is_finished() -> bool:
	return true
