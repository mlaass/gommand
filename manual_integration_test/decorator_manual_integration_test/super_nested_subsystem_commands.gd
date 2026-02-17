extends Node3D


class ArmSubsystem:
	extends Subsystem

	var _idle_accumulator := 0.0

	func idle_tick(delta_time: float) -> void:
		_idle_accumulator += delta_time
		if _idle_accumulator >= 0.75:
			_idle_accumulator = 0.0
			print("ArmSubsystem: idle default")


var arm: ArmSubsystem
var _flip: bool = false


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: super nested command on subsystem")
	print("Default idle should pause during busy nested command, then resume.")

	arm = ArmSubsystem.new()
	arm.set_default_command(RunCommand.new(func(dt): arm.idle_tick(dt), [arm]))

	CommandScheduler.schedule(
		SequentialCommandGroup.new([
			PrintCommand.new("NestedSubsystem: busy sequence start"),
			UninterruptibleCommand.new(_build_busy_nested_command()),
			PrintCommand.new("NestedSubsystem: busy sequence end")
		])
	)

	await get_tree().create_timer(4.0).timeout
	arm.set_default_command(null)
	arm = null
	print("NestedSubsystem: done")


func _build_busy_nested_command() -> Command:
	return RepeatCommand.new(
		ConditionalCommand.new(
			Callable(self, "_next_flip"),
			SequentialCommandGroup.new([
				PrintCommand.new("Busy: true branch"),
				ParallelCommandGroup.new([
					WaitCommand.new(0.2, [arm]),
					DeferredCommand.new(func():
					return SequentialCommandGroup.new([
							PrintCommand.new("Busy: deferred step"),
							WaitCommand.new(0.1, [arm])
						])
					)
				])
			]),
			SequentialCommandGroup.new([
				PrintCommand.new("Busy: false branch"),
				SelectCommand.new(
					Callable(self, "_select_phase"),
					{
						"a": WaitCommand.new(0.15, [arm]),
						"b": SequentialCommandGroup.new([
							WaitCommand.new(0.05, [arm]),
							PrintCommand.new("Busy: select b")
						])
					}
				)
			])
		),
		4
	)


func _next_flip() -> bool:
	_flip = not _flip
	return _flip


func _select_phase() -> String:
	return "a" if Time.get_ticks_msec() % 2 == 0 else "b"
