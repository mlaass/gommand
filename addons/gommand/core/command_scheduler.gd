extends Node

const CommandState = preload("command_state.gd")
const FunctionalTools = preload("../scripts/functional_tools.gd")

var _active_commands: Array = []
var _command_states: Dictionary = {}
var _subsystem_usage: Dictionary = {}
var _subsystems: Array = []
var _action_triggers: Array = []


func _ready() -> void:
	set_process(true)
	set_physics_process(true)


func _process(delta_time: float) -> void:
	run(delta_time)


func _physics_process(delta_time: float) -> void:
	physics_run(delta_time)


func run(delta_time: float) -> void:
	_update_action_triggers()

	FunctionalTools.for_each(
		FunctionalTools.filter(_subsystems, func(subsystem): return is_instance_valid(subsystem)),
		func(subsystem): subsystem.periodic(delta_time)
	)

	var commands_to_remove: Array = FunctionalTools.filter(
		_active_commands,
		func(command):
			if not is_instance_valid(command):
				return true
			if not command._has_initialized():
				command.initialize()
				command._mark_initialized()
			command.execute(delta_time)
			if command.is_finished():
				command.end(false)
				return true
			return false
	)
	FunctionalTools.for_each(commands_to_remove, func(command): _unschedule(command))

	FunctionalTools.for_each(
		FunctionalTools.filter(
			_subsystems,
			func(subsystem):
				return (
					is_instance_valid(subsystem)
					and _is_subsystem_idle(subsystem)
					and subsystem.default_command != null
					and not _is_scheduled(subsystem.default_command)
				)),
		func(subsystem): schedule(subsystem.default_command)
	)


func physics_run(delta_time: float) -> void:
	FunctionalTools.for_each(
		FunctionalTools.filter(_subsystems, func(subsystem): return is_instance_valid(subsystem)),
		func(subsystem): subsystem.physics_periodic(delta_time)
	)

	FunctionalTools.for_each(
		FunctionalTools.filter(
			_active_commands,
			func(command): return is_instance_valid(command) and command._has_initialized()
		),
		func(command): command.physics_execute(delta_time)
	)


func schedule(command: Command) -> bool:
	if command == null:
		return false
	return _schedule_internal(command)


func _schedule_internal(command: Command) -> bool:
	var requirements := command.get_requirements()
	var conflicting_commands: Array = FunctionalTools.filter(
		FunctionalTools.map(
			FunctionalTools.filter(
				requirements, func(subsystem): return _subsystem_usage.has(subsystem)
			),
			func(subsystem): return _subsystem_usage[subsystem]
		),
		func(occupying_command): return occupying_command != command
	)
	var unique_conflicts: Array = []
	FunctionalTools.for_each(
		conflicting_commands,
		func(conflicting_command):
			if not unique_conflicts.has(conflicting_command):
				unique_conflicts.append(conflicting_command)
	)
	if FunctionalTools.any(
		unique_conflicts,
		func(conflicting_command): return not _is_interruptible(conflicting_command)
	):
		return false
	FunctionalTools.for_each(
		unique_conflicts, func(conflicting_command): cancel(conflicting_command)
	)
	_command_states[command] = CommandState.new(command.is_interruptible())
	_command_mark_scheduled(command)
	_active_commands.append(command)
	FunctionalTools.for_each(requirements, func(subsystem): _subsystem_usage[subsystem] = command)
	return true


func cancel(command: Command) -> void:
	if command == null:
		return
	_cancel_internal(command)


func _cancel_internal(command: Command) -> bool:
	if _active_commands.has(command):
		command.end(true)
		_unschedule(command)
	return true


func cancel_all() -> void:
	FunctionalTools.for_each(_active_commands.duplicate(), func(command): cancel(command))


func is_scheduled(command: Command) -> bool:
	return _is_scheduled(command)


func register_subsystem(subsystem: Subsystem) -> void:
	if not _subsystems.has(subsystem):
		_subsystems.append(subsystem)


func unregister_subsystem(subsystem: Subsystem) -> void:
	_subsystems.erase(subsystem)
	if _subsystem_usage.has(subsystem):
		var command_in_use: Command = _subsystem_usage[subsystem]
		_subsystem_usage.erase(subsystem)
		if is_instance_valid(command_in_use) and _active_commands.has(command_in_use):
			pass


func register_action_trigger(action_trigger) -> void:
	if not _action_triggers.has(action_trigger):
		_action_triggers.append(action_trigger)


func unregister_action_trigger(action_trigger) -> void:
	_action_triggers.erase(action_trigger)


func _unschedule(command: Command) -> void:
	if command == null:
		return
	_unschedule_internal(command)


func _unschedule_internal(command: Command) -> bool:
	_active_commands.erase(command)
	_command_states.erase(command)
	FunctionalTools.for_each(
		FunctionalTools.filter(
			command.get_requirements(),
			func(subsystem): return _subsystem_usage.get(subsystem) == command
		),
		func(subsystem): _subsystem_usage.erase(subsystem)
	)
	command._on_unscheduled()
	return true


func _is_subsystem_idle(subsystem: Subsystem) -> bool:
	return not _subsystem_usage.has(subsystem)


func _is_scheduled(command: Command) -> bool:
	return _active_commands.has(command)


func _command_mark_scheduled(command: Command) -> void:
	if not command._is_scheduled():
		command._on_scheduled()


func _is_interruptible(command: Command) -> bool:
	var state = _command_states.get(command)
	return state.is_interruptible() if state != null else command.is_interruptible()


func _update_action_triggers() -> void:
	FunctionalTools.for_each(
		FunctionalTools.filter(
			_action_triggers, func(action_trigger): return action_trigger != null
		),
		func(action_trigger): action_trigger._update()
	)
