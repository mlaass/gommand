class_name PerpetualCommand
extends Command

const Guard = preload("../../scripts/guard.gd")
const FunctionalTools = preload("../../scripts/functional_tools.gd")
var _inner_command: Command = null


func _init(inner_command: Command) -> void:
	_inner_command = inner_command
	super._init([], inner_command.is_interruptible())
	if _inner_command != null:
		FunctionalTools.for_each(
			_inner_command.get_requirements(), func(subsystem): add_requirement(subsystem)
		)


func initialize() -> void:
	Guard.against_null(_inner_command)
	_initialize_inner()


func _on_scheduled() -> void:
	super._on_scheduled()
	Guard.against_null(_inner_command)
	_on_scheduled_inner()


func execute(delta_time: float) -> void:
	Guard.against_null(_inner_command)
	_execute_inner(delta_time)


func physics_execute(delta_time: float) -> void:
	Guard.against_null(_inner_command)
	_physics_execute_inner(delta_time)


func is_finished() -> bool:
	return false


func end(interrupted: bool) -> void:
	Guard.against_null(_inner_command)
	_end_inner(interrupted)


func _end_inner(interrupted: bool) -> void:
	if not _inner_command.is_finished():
		_inner_command.end(interrupted)


func _initialize_inner() -> void:
	if not _inner_command._has_initialized():
		_inner_command.initialize()
		_inner_command._mark_initialized()


func _on_scheduled_inner() -> void:
	_inner_command._on_scheduled()


func _execute_inner(delta_time: float) -> void:
	_inner_command.execute(delta_time)


func _physics_execute_inner(delta_time: float) -> void:
	_inner_command.physics_execute(delta_time)
