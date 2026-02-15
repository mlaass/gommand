class_name CommandState
extends RefCounted

var _interruptible: bool


func _init(interruptible: bool) -> void:
	_interruptible = interruptible


func is_interruptible() -> bool:
	return _interruptible
