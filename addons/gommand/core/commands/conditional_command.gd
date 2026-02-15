class_name ConditionalCommand
extends Command

const FunctionalTools = preload("../../scripts/functional_tools.gd")
var _condition_callable: Callable = Callable()
var _on_true_command: Command = null
var _on_false_command: Command = null
var _active_command: Command = null


func _init(
	condition_callable: Callable, on_true_command: Command, on_false_command: Command = null
) -> void:
	_condition_callable = condition_callable
	_on_true_command = on_true_command
	_on_false_command = on_false_command
	super._init([], true)
	if _on_true_command != null:
		FunctionalTools.for_each(
			_on_true_command.get_requirements(), func(subsystem): add_requirement(subsystem)
		)
	if _on_false_command != null:
		FunctionalTools.for_each(
			_on_false_command.get_requirements(), func(subsystem): add_requirement(subsystem)
		)


func initialize() -> void:
	var condition_result := _condition_callable.is_valid() and bool(_condition_callable.call())
	_active_command = _on_true_command if condition_result else _on_false_command
	if _active_command != null and not _active_command._has_initialized():
		_active_command.initialize()
		_active_command._mark_initialized()


func execute(delta_time: float) -> void:
	if _active_command != null:
		_active_command.execute(delta_time)


func physics_execute(delta_time: float) -> void:
	if _active_command != null:
		_active_command.physics_execute(delta_time)


func is_finished() -> bool:
	return _active_command == null or _active_command.is_finished()


func end(interrupted: bool) -> void:
	if _active_command != null:
		_active_command.end(interrupted)


func _on_scheduled() -> void:
	super._on_scheduled()
	if _on_true_command != null:
		_on_true_command._on_scheduled()
	if _on_false_command != null:
		_on_false_command._on_scheduled()
