class_name ParallelDeadlineGroup
extends Command

const FunctionalTools = preload("../../scripts/functional_tools.gd")
var _deadline_command: Command = null
var _commands: Array = []


func _init(deadline_command: Command, commands: Array = [], interruptible: bool = true) -> void:
	_deadline_command = deadline_command
	_commands = commands.duplicate()
	super._init([], interruptible)
	if _deadline_command != null:
		FunctionalTools.for_each(
			_deadline_command.get_requirements(), func(subsystem): add_requirement(subsystem)
		)
	FunctionalTools.for_each(
		FunctionalTools.filter(_commands, func(child_command): return child_command != null),
		func(child_command): _adopt_requirements(child_command)
	)


func initialize() -> void:
	if _deadline_command and not _deadline_command._has_initialized():
		_deadline_command.initialize()
		_deadline_command._mark_initialized()
	FunctionalTools.for_each(
		FunctionalTools.filter(_commands, func(command): return command != null),
		func(command): _initialize_child(command)
	)


func execute(delta_time: float) -> void:
	if _deadline_command and not _deadline_command.is_finished():
		_deadline_command.execute(delta_time)
	FunctionalTools.for_each(
		FunctionalTools.filter(
			_commands, func(command): return command != null and not command.is_finished()
		),
		func(command): command.execute(delta_time)
	)
	if _deadline_command and _deadline_command.is_finished():
		_deadline_command.end(false)


func physics_execute(delta_time: float) -> void:
	if _deadline_command and not _deadline_command.is_finished():
		_deadline_command.physics_execute(delta_time)
	FunctionalTools.for_each(
		FunctionalTools.filter(
			_commands, func(command): return command != null and not command.is_finished()
		),
		func(command): command.physics_execute(delta_time)
	)
	if _deadline_command and _deadline_command.is_finished():
		_deadline_command.end(false)


func is_finished() -> bool:
	return _deadline_command != null and _deadline_command.is_finished()


func end(interrupted: bool) -> void:
	# end all running commands
	if _deadline_command and not _deadline_command.is_finished():
		_deadline_command.end(interrupted)
	FunctionalTools.for_each(
		FunctionalTools.filter(
			_commands, func(command): return command != null and not command.is_finished()
		),
		func(command): command.end(interrupted)
	)


func _on_scheduled() -> void:
	super._on_scheduled()
	if _deadline_command != null:
		_deadline_command._on_scheduled()
	FunctionalTools.for_each(
		FunctionalTools.filter(_commands, func(command): return command != null),
		func(command): _schedule_child(command)
	)


func _adopt_requirements(child_command: Command) -> void:
	FunctionalTools.for_each(
		child_command.get_requirements(), func(subsystem): add_requirement(subsystem)
	)


func _initialize_child(command: Command) -> void:
	if not command._has_initialized():
		command.initialize()
		command._mark_initialized()


func _schedule_child(command: Command) -> void:
	command._on_scheduled()
