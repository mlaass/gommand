class_name SequentialCommandGroup
extends Command

const Guard = preload("../../scripts/guard.gd")
const FunctionalTools = preload("../../scripts/functional_tools.gd")
var _commands: Array = []
var _current_index: int = 0


func _init(commands: Array = [], interruptible: bool = true) -> void:
	_commands = commands.duplicate()
	super._init([], interruptible)
	FunctionalTools.for_each(
		FunctionalTools.filter(_commands, func(child_command): return child_command != null),
		func(child_command): _adopt_requirements(child_command)
	)


func initialize() -> void:
	_current_index = 0
	if _commands.is_empty():
		return
	var current_command = _commands[_current_index]
	Guard.against_null(current_command)
	_initialize_current(current_command)


func execute(delta_time: float) -> void:
	if _current_index >= _commands.size():
		return
	var current_command = _commands[_current_index]
	Guard.against_null(current_command)
	_execute_current(current_command, delta_time)


func physics_execute(delta_time: float) -> void:
	if _current_index >= _commands.size():
		return
	var current_command = _commands[_current_index]
	Guard.against_null(current_command)
	_physics_execute_current(current_command, delta_time)


func is_finished() -> bool:
	return _current_index >= _commands.size()


func end(interrupted: bool) -> void:
	# If interrupted mid-sequence, end current command.
	if interrupted and _current_index < _commands.size():
		var current_command = _commands[_current_index]
		Guard.against_null(current_command)
		_end_current(current_command)


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


func _initialize_current(command: Command) -> void:
	if not command._has_initialized():
		command.initialize()
		command._mark_initialized()


func _execute_current(command: Command, delta_time: float) -> void:
	command.execute(delta_time)
	if command.is_finished():
		command.end(false)
		_current_index += 1
		if _current_index < _commands.size():
			var next_command = _commands[_current_index]
			if not next_command._has_initialized():
				next_command.initialize()
				next_command._mark_initialized()


func _physics_execute_current(command: Command, delta_time: float) -> void:
	command.physics_execute(delta_time)
	if command.is_finished():
		command.end(false)
		_current_index += 1
		if _current_index < _commands.size():
			var next_command = _commands[_current_index]
			if not next_command._has_initialized():
				next_command.initialize()
				next_command._mark_initialized()


func _schedule_child(command: Command) -> void:
	command._on_scheduled()


func _end_current(command: Command) -> void:
	command.end(true)
