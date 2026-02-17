extends Node3D


class DriveSubsystem:
	extends Subsystem


var _subsystem: DriveSubsystem


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: Default command ticks, pauses during conflicting command, then resumes.")

	_subsystem = DriveSubsystem.new()
	_subsystem.set_default_command(
		SequentialCommandGroup.new([
			PrintCommand.new("SubsystemConflict: default tick"),
			WaitCommand.new(0.5, [_subsystem])
		])
	)

	await get_tree().create_timer(1.0).timeout
	var busy := SequentialCommandGroup.new([
		PrintCommand.new("SubsystemConflict: BUSY start (default should pause)"),
		WaitCommand.new(2.0, [_subsystem]),
		PrintCommand.new("SubsystemConflict: BUSY end (default should resume)")
	])
	CommandScheduler.schedule(busy)

	await get_tree().create_timer(4.0).timeout
	_subsystem.set_default_command(null)
	_subsystem = null
	print("SubsystemConflict: done")
