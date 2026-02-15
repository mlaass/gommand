class_name ParallelCommandGroup
extends Command

# Runs commands in parallel; finishes when all are done.

const FunctionalTools = preload("../../scripts/functional_tools.gd")

var _commands: Array = []


func _init(commands: Array = [], interruptible: bool = true) -> void:
	_commands = commands.duplicate()
	super._init([], interruptible)
	FunctionalTools.for_each(
		FunctionalTools.filter(_commands, func(child_command): return child_command != null),
		func(child_command): _adopt_requirements(child_command)
	)


func initialize() -> void:
	# Initialize all children
	FunctionalTools.for_each(
		FunctionalTools.filter(_commands, func(command): return command != null),
		func(command): _initialize_child(command)
	)


func execute(delta_time: float) -> void:
	FunctionalTools.for_each(
		FunctionalTools.filter(_commands, func(command): return command != null),
		func(command): _execute_child(command, delta_time)
	)


func physics_execute(delta_time: float) -> void:
	FunctionalTools.for_each(
		FunctionalTools.filter(_commands, func(command): return command != null),
		func(command): _physics_execute_child(command, delta_time)
	)


func is_finished() -> bool:
	return FunctionalTools.all(
		FunctionalTools.filter(_commands, func(command): return command != null),
		func(command): return command.is_finished()
	)


func end(interrupted: bool) -> void:
	if interrupted:
		FunctionalTools.for_each(
			FunctionalTools.filter(
				_commands, func(command): return command != null and not command.is_finished()
			),
			func(command): command.end(true)
		)


func _on_scheduled() -> void:
	super._on_scheduled()
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


func _execute_child(command: Command, delta_time: float) -> void:
	if command.is_finished():
		return
	command.execute(delta_time)
	if command.is_finished():
		command.end(false)


func _physics_execute_child(command: Command, delta_time: float) -> void:
	if command.is_finished():
		return
	command.physics_execute(delta_time)
	if command.is_finished():
		command.end(false)


func _schedule_child(command: Command) -> void:
	command._on_scheduled()
