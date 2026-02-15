class_name ScheduleCommand
extends Command

# When executed, schedules the provided command via the scheduler and then finishes.
const Guard = preload("../../scripts/guard.gd")
var _command_to_schedule: Command = null


func _init(command_to_schedule: Command) -> void:
	_command_to_schedule = command_to_schedule
	super._init([], true)


func initialize() -> void:
	Guard.against_null(_command_to_schedule)
	Guard.against_false(Engine.has_singleton("CommandScheduler"))
	CommandScheduler.schedule(_command_to_schedule)


func physics_execute(delta_time: float) -> void:
	pass


func is_finished() -> bool:
	return true
