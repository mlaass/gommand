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
	var registered_subsystems: Array = _get_registered_subsystems()

	FunctionalTools.for_each(
		registered_subsystems,
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
			registered_subsystems,
			func(subsystem):
				var default_command: Command = subsystem.default_command
				return (
					_is_subsystem_idle(subsystem)
					and default_command != null
					and not _is_scheduled(default_command)
				)),
		func(subsystem): schedule(subsystem.default_command)
	)


func physics_run(delta_time: float) -> void:
	var registered_subsystems: Array = _get_registered_subsystems()
	FunctionalTools.for_each(
		registered_subsystems,
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
	var requirement_ids: Array = FunctionalTools.map(
		FunctionalTools.filter(requirements, func(subsystem): return is_instance_valid(subsystem)),
		func(subsystem): return subsystem.get_instance_id()
	)
	var conflicting_commands: Array = FunctionalTools.filter(
		FunctionalTools.map(
			FunctionalTools.filter(
				requirement_ids, func(subsystem_id): return _subsystem_usage.has(subsystem_id)
			),
			func(subsystem_id): return _subsystem_usage[subsystem_id]
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
	FunctionalTools.for_each(
		requirement_ids, func(subsystem_id): _subsystem_usage[subsystem_id] = command
	)
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
	if not is_instance_valid(subsystem):
		return
	var subsystem_id := subsystem.get_instance_id()
	if not _subsystems.has(subsystem_id):
		_subsystems.append(subsystem_id)


func unregister_subsystem(subsystem: Subsystem) -> void:
	if not is_instance_valid(subsystem):
		return
	var subsystem_id := subsystem.get_instance_id()
	_subsystems.erase(subsystem_id)
	if _subsystem_usage.has(subsystem_id):
		var command_in_use: Command = _subsystem_usage[subsystem_id]
		_subsystem_usage.erase(subsystem_id)
		if is_instance_valid(command_in_use) and _active_commands.has(command_in_use):
			pass


func register_action_trigger(action_trigger) -> void:
	if action_trigger == null:
		return
	var already_registered := FunctionalTools.any(
		_action_triggers,
		func(action_trigger_ref):
			var existing_trigger = action_trigger_ref.get_ref() if action_trigger_ref != null else null
			return existing_trigger == action_trigger
	)
	if not already_registered:
		_action_triggers.append(weakref(action_trigger))


func unregister_action_trigger(action_trigger) -> void:
	var stale_trigger_refs: Array = []
	FunctionalTools.for_each(
		_action_triggers,
		func(action_trigger_ref):
			var existing_trigger = action_trigger_ref.get_ref() if action_trigger_ref != null else null
			if existing_trigger == null or existing_trigger == action_trigger:
				stale_trigger_refs.append(action_trigger_ref)
	)
	FunctionalTools.for_each(stale_trigger_refs, func(action_trigger_ref): _action_triggers.erase(action_trigger_ref))


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
			func(subsystem): return (
					is_instance_valid(subsystem)
					and _subsystem_usage.get(subsystem.get_instance_id()) == command
			)
		),
		func(subsystem): _subsystem_usage.erase(subsystem.get_instance_id())
	)
	command._on_unscheduled()
	return true


func _is_subsystem_idle(subsystem: Subsystem) -> bool:
	return is_instance_valid(subsystem) and not _subsystem_usage.has(subsystem.get_instance_id())


func _get_registered_subsystems() -> Array:
	var live_subsystems: Array = []
	var stale_subsystem_ids: Array = []
	FunctionalTools.for_each(
		_subsystems,
		func(subsystem_id):
			var subsystem = instance_from_id(subsystem_id)
			if subsystem != null and is_instance_valid(subsystem):
				live_subsystems.append(subsystem)
			else:
				stale_subsystem_ids.append(subsystem_id)
	)
	FunctionalTools.for_each(
		stale_subsystem_ids,
		func(stale_subsystem_id):
			_subsystems.erase(stale_subsystem_id)
			_subsystem_usage.erase(stale_subsystem_id)
	)
	return live_subsystems


func _is_scheduled(command: Command) -> bool:
	return _active_commands.has(command)


func _command_mark_scheduled(command: Command) -> void:
	if not command._is_scheduled():
		command._on_scheduled()


func _is_interruptible(command: Command) -> bool:
	var state = _command_states.get(command)
	return state.is_interruptible() if state != null else command.is_interruptible()


func _update_action_triggers() -> void:
	var live_action_triggers: Array = []
	var stale_trigger_refs: Array = []
	FunctionalTools.for_each(
		_action_triggers,
		func(action_trigger_ref):
			var action_trigger = action_trigger_ref.get_ref() if action_trigger_ref != null else null
			if action_trigger != null:
				live_action_triggers.append(action_trigger)
			else:
				stale_trigger_refs.append(action_trigger_ref)
	)
	FunctionalTools.for_each(stale_trigger_refs, func(action_trigger_ref): _action_triggers.erase(action_trigger_ref))
	FunctionalTools.for_each(live_action_triggers, func(action_trigger): action_trigger._update())
