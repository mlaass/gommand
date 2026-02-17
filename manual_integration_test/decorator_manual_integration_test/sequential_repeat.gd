extends Node3D


func _ready() -> void:
	await get_tree().process_frame
	CommandScheduler.schedule(
		PrintCommand.new("EXPECT: Sequential_repeat -> Seq A, wait, Seq B (x2)")
	)
	var seq := SequentialCommandGroup.new(
		[PrintCommand.new("Seq A"), WaitCommand.new(2.5), PrintCommand.new("Seq B")]
	)
	CommandScheduler.schedule(RepeatCommand.new(seq, 2))
