extends Node3D

var _start_ms: int = 0


func _ready() -> void:
	await get_tree().process_frame
	CommandScheduler.schedule(
		PrintCommand.new(
			"EXPECT: ParallelRace_waituntil_repeat -> Repeat should be interrupted when WaitUntil becomes true (~1.5s)"
		)
	)
	_start_ms = Time.get_ticks_msec()
	var waiter := WaitUntilCommand.new(Callable(self, "_wait_predicate"))
	var inner := ParallelCommandGroup.new(
		[PrintCommand.new("RepeatRace: tick"), WaitCommand.new(0.3)]
	)
	CommandScheduler.schedule(ParallelRaceGroup.new([waiter, RepeatCommand.new(inner, 0)]))


func _wait_predicate() -> bool:
	return Time.get_ticks_msec() - _start_ms >= 1500
