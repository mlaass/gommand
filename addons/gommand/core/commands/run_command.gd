class_name RunCommand
extends Command

# Runs a callable each execute; never finishes unless canceled.
const Guard = preload("../../scripts/guard.gd")
var _runnable: Callable = Callable()


func _init(
	runnable_callable: Callable, requirements: Array = [], interruptible: bool = true
) -> void:
	_runnable = runnable_callable
	super._init(requirements, interruptible)


func execute(delta_time: float) -> void:
	Guard.against_false(_runnable.is_valid())
	_run(delta_time)


func physics_execute(delta_time: float) -> void:
	Guard.against_false(_runnable.is_valid())
	_run(delta_time)


func _run(delta_time: float) -> void:
	_runnable.call(delta_time)


func is_finished() -> bool:
	return false
