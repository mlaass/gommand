extends Node3D


func _ready() -> void:
	await get_tree().process_frame
	CommandScheduler.schedule(
		PrintCommand.new("EXPECT: Repeat_print -> inner will print 3 times")
	)
	CommandScheduler.schedule(
		RepeatCommand.new(
			ParallelCommandGroup.new([PrintCommand.new("Repeat: Hello"), WaitCommand.new(0.5)]),
			3
		)
	)
