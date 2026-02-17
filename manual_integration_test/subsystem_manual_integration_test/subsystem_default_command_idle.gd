extends Node3D


class DriveSubsystem:
	extends Subsystem


var _subsystem: DriveSubsystem


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: Subsystem default command runs while subsystem is idle.")
	print("You should see 'SubsystemDefaultIdle: tick' every ~0.5s for ~3 seconds.")

	_subsystem = DriveSubsystem.new()
	_subsystem.set_default_command(
		SequentialCommandGroup.new([
			PrintCommand.new("SubsystemDefaultIdle: tick"),
			WaitCommand.new(0.5, [_subsystem])
		])
	)

	await get_tree().create_timer(3.0).timeout
	_subsystem.set_default_command(null)
	_subsystem = null
	print("SubsystemDefaultIdle: done")
