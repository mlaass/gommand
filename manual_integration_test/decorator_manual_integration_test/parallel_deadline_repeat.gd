extends Node3D


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: ParallelDeadline repeat test")
	print("Worker should print tick ~every 0.2s, then stop around 1.2s when deadline finishes.")

	var deadline := WaitCommand.new(1.2)
	var worker := RepeatCommand.new(
		SequentialCommandGroup.new(
			[
				PrintCommand.new("DeadlineWorker: tick"),
				WaitCommand.new(0.2)
			]
		),
		0
	)
	var group := ParallelDeadlineGroup.new(deadline, [worker])
	CommandScheduler.schedule(group)
