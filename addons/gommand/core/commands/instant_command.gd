class_name InstantCommand
extends Command

const Guard = preload("../../scripts/guard.gd")
var _action_to_run: Callable = Callable()


func _init(
	action_to_run: Callable = Callable(), requirements: Array = [], interruptible: bool = true
) -> void:
	_action_to_run = action_to_run
	super._init(requirements, interruptible)


func initialize() -> void:
	Guard.against_false(_action_to_run.is_valid())
	_run_action()


func _run_action() -> void:
	_action_to_run.call()


func is_finished() -> bool:
	return true
