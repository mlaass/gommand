extends Node3D


func _ready() -> void:
	await get_tree().process_frame
	CommandScheduler.schedule(
		PrintCommand.new("EXPECT: Conditional_repeat -> TRUE branch runs Repeat x2")
	)
	var inner := ParallelCommandGroup.new(
		[PrintCommand.new("ConditionalRepeat: hello"), WaitCommand.new(0.2)]
	)
	CommandScheduler.schedule(
		ConditionalCommand.new(
			Callable(self, "_condition_true"),
			RepeatCommand.new(inner, 2),
			PrintCommand.new("CondRepeat: FALSE")
		)
	)


func _condition_true() -> bool:
	return true
