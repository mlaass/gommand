class_name StartEndCommand
extends Command

const Guard = preload("../../scripts/guard.gd")
var _on_start_callable: Callable = Callable()
var _on_end_callable: Callable = Callable()


func _init(
	on_start_callable: Callable,
	on_end_callable: Callable,
	requirements: Array = [],
	interruptible: bool = true
) -> void:
	_on_start_callable = on_start_callable
	_on_end_callable = on_end_callable
	super._init(requirements, interruptible)


func initialize() -> void:
	Guard.against_false(_on_start_callable.is_valid())
	_call_on_start()


func execute(delta_time: float) -> void:
	pass


func physics_execute(delta_time: float) -> void:
	pass


func is_finished() -> bool:
	return false


func end(interrupted: bool) -> void:
	Guard.against_false(_on_end_callable.is_valid())
	_call_on_end()


func _call_on_start() -> void:
	_on_start_callable.call()


func _call_on_end() -> void:
	_on_end_callable.call()
