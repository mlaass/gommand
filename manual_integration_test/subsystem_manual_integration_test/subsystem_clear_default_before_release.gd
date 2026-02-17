extends Node3D


class DriveSubsystem:
	extends Subsystem


var _subsystem: DriveSubsystem


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: Clear default command before releasing subsystem instance.")
	print("You should stop seeing ticks after clear/release.")

	_subsystem = DriveSubsystem.new()
	_subsystem.set_default_command(
		SequentialCommandGroup.new([
			PrintCommand.new("SubsystemRelease: default tick"),
			WaitCommand.new(0.5, [_subsystem])
		])
	)

	await get_tree().create_timer(2.0).timeout
	print("SubsystemRelease: clearing default + releasing subsystem")
	_subsystem.set_default_command(null)
	_subsystem = null

	await get_tree().create_timer(2.0).timeout
	print("SubsystemRelease: done")
