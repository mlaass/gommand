extends Node3D

var _start_ms: int = 0
var _use_fast_branch: bool = true


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: super nested decorators and command groups")
	print("Run 1: fast branch with nested repeat/parallel/race/deadline")
	print("Run 2: select slow branch")

	_start_ms = Time.get_ticks_msec()
	CommandScheduler.schedule(_build_nested_command())

	await get_tree().create_timer(2.0).timeout
	_use_fast_branch = false
	CommandScheduler.schedule(
		SelectCommand.new(
			Callable(self, "_select_key"),
			{
				"fast": PrintCommand.new("NestedMap: FAST"),
				"slow": PrintCommand.new("NestedMap: SLOW")
			}
		)
	)


func _build_nested_command() -> Command:
	var race_repeat := RepeatCommand.new(
		SequentialCommandGroup.new([
			PrintCommand.new("NestedRace: tick"),
			ParallelRaceGroup.new([
				WaitUntilCommand.new(Callable(self, "_after_600ms")),
				WaitCommand.new(0.2)
			])
		]),
		3
	)

	var selected := SelectCommand.new(
		Callable(self, "_select_key"),
		{
			"fast": ParallelDeadlineGroup.new(
				WaitCommand.new(1.1),
				[
					RepeatCommand.new(
						SequentialCommandGroup.new([
							PrintCommand.new("NestedMap: fast tick"),
							WaitCommand.new(0.15)
						]),
						0
					)
				]
			),
			"slow": SequentialCommandGroup.new([
				WaitCommand.new(0.3),
				PrintCommand.new("NestedMap: slow path")
			])
		}
	)

	return SequentialCommandGroup.new([
		PrintCommand.new("Nested: start"),
		ConditionalCommand.new(
			Callable(self, "_is_fast"),
			UninterruptibleCommand.new(
				ParallelCommandGroup.new([
					race_repeat,
					selected
				])
			),
			PrintCommand.new("Nested: false branch")
		),
		DeferredCommand.new(Callable(self, "_make_finish_command")),
		PrintCommand.new("Nested: done")
	])


func _after_600ms() -> bool:
	return Time.get_ticks_msec() - _start_ms >= 600


func _is_fast() -> bool:
	return _use_fast_branch


func _select_key() -> String:
	return "fast" if _use_fast_branch else "slow"


func _make_finish_command() -> Command:
	return SequentialCommandGroup.new([
		PrintCommand.new("Nested: deferred finish"),
		WaitCommand.new(0.1)
	])
