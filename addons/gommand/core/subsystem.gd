@icon("../assets/editor_icons/gear.svg")
class_name Subsystem
extends RefCounted

const FunctionalTools = preload("../scripts/functional_tools.gd")
var default_command: Command = null


func _init() -> void:
	CommandScheduler.register_subsystem(self)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		default_command = null
		CommandScheduler.unregister_subsystem(self)


func periodic(delta_time: float) -> void:
	pass


func physics_periodic(delta_time: float) -> void:
	pass


func set_default_command(command: Command) -> void:
	if command == null:
		default_command = null
		return
	if not _command_requires_self(command):
		push_warning("Default command must require this subsystem")
	default_command = command


func _command_requires_self(command: Command) -> bool:
	return FunctionalTools.any(
		command.get_requirements(), func(subsystem): return subsystem == self
	)
