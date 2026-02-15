class_name WaitUntilCommand
extends Command

var _predicate: Callable = Callable()


func _init(predicate: Callable) -> void:
	_predicate = predicate
	super._init([], true)


func is_finished() -> bool:
	return _predicate.is_valid() and bool(_predicate.call())


func physics_execute(delta_time: float) -> void:
	pass
