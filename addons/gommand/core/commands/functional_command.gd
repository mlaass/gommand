class_name FunctionalCommand
extends Command

const Guard = preload("../../scripts/guard.gd")
var _initialize_callable: Callable = Callable()
var _execute_callable: Callable = Callable()
var _end_callable: Callable = Callable()
var _is_finished_callable: Callable = Callable()


func _init(
	initialize_callable: Callable,
	execute_callable: Callable,
	end_callable: Callable,
	is_finished_callable: Callable,
	requirements: Array = [],
	interruptible: bool = true
) -> void:
	_initialize_callable = initialize_callable
	_execute_callable = execute_callable
	_end_callable = end_callable
	_is_finished_callable = is_finished_callable
	super._init(requirements, interruptible)


func initialize() -> void:
	Guard.against_false(_initialize_callable.is_valid())
	_call_initialize()


func execute(delta_time: float) -> void:
	Guard.against_false(_execute_callable.is_valid())
	_call_execute(delta_time)


func physics_execute(delta_time: float) -> void:
	Guard.against_false(_execute_callable.is_valid())
	_call_execute(delta_time)


func is_finished() -> bool:
	return not _is_finished_callable.is_valid() or bool(_is_finished_callable.call())


func end(interrupted: bool) -> void:
	Guard.against_false(_end_callable.is_valid())
	_call_end(interrupted)


func _call_initialize() -> void:
	_initialize_callable.call()


func _call_execute(delta_time: float) -> void:
	_execute_callable.call(delta_time)


func _call_end(interrupted: bool) -> void:
	_end_callable.call(interrupted)
